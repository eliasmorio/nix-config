{
  description = "NixOS and Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      deploy-rs,
      ...
    }:
    let
      # System architectures
      x86System = "x86_64-linux";
      armSystem = "aarch64-linux";
      darwinSystem = "aarch64-darwin";

      # Package sets for each architecture
      pkgsX86 = nixpkgs.legacyPackages.${x86System};
      pkgsArm = nixpkgs.legacyPackages.${armSystem};
      pkgsDarwin = nixpkgs.legacyPackages.${darwinSystem};

      # Common home-manager configuration for NixOS module integration
      homeManagerModule = hostName: {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.emorio = import ./hosts/${hostName}/home.nix;
        };
      };
    in
    {
      # NixOS configurations
      nixosConfigurations = {
        thinkserver1 = nixpkgs.lib.nixosSystem {
          system = x86System;
          modules = [
            home-manager.nixosModules.home-manager
            (homeManagerModule "thinkserver1")
            ./hosts/thinkserver1/configuration.nix
          ];
        };

        radxa-rock5b-1 = nixpkgs.lib.nixosSystem {
          system = armSystem;
          modules = [
            home-manager.nixosModules.home-manager
            (homeManagerModule "radxa-rock5b-1")
            ./hosts/radxa-rock5b-1/configuration.nix
          ];
        };

        # VM for kernel development on UTM (Apple Silicon)
        dev-vm = nixpkgs.lib.nixosSystem {
          system = armSystem;
          modules = [
            home-manager.nixosModules.home-manager
            (homeManagerModule "dev-vm")
            ./hosts/dev-vm/configuration.nix
            ./hosts/dev-vm/disk-image.nix
          ];
        };

        # ROCK 5B flashable image (for dd to NVMe)
        radxa-rock5b-1-image = nixpkgs.lib.nixosSystem {
          system = armSystem;
          modules = [
            home-manager.nixosModules.home-manager
            (homeManagerModule "radxa-rock5b-1")
            ./hosts/radxa-rock5b-1/configuration-image.nix
          ];
        };
      };

      # deploy-rs configuration
      deploy.nodes = {
        thinkserver1 = {
          hostname = "192.168.2.201";
          remoteBuild = true;
          profiles.system = {
            user = "root";
            sshUser = "emorio";
            sudo = "sudo -u";
            magicRollback = true;
            autoRollback = true;
            path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.thinkserver1;
          };
        };

        radxa-rock5b-1 = {
          hostname = "192.168.2.73";
          remoteBuild = true;
          profiles.system = {
            user = "root";
            sshUser = "emorio";
            sudo = "sudo -u";
            magicRollback = true;
            autoRollback = true;
            path = deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.radxa-rock5b-1;
          };
        };
      };

      # Validation checks for deploy-rs
      # Only include checks for systems that can actually run them
      checks = {
        ${x86System} = deploy-rs.lib.${x86System}.deployChecks self.deploy;
        ${armSystem} = deploy-rs.lib.${armSystem}.deployChecks self.deploy;
      };

      # Formatter for `nix fmt`
      formatter = {
        ${x86System} = pkgsX86.nixfmt;
        ${armSystem} = pkgsArm.nixfmt;
        ${darwinSystem} = pkgsDarwin.nixfmt;
      };

      # Development shell with nix tooling
      devShells = {
        ${x86System}.default = pkgsX86.mkShell {
          packages = with pkgsX86; [
            nil
            nixfmt
            statix
          ];
        };
        ${armSystem}.default = pkgsArm.mkShell {
          packages = with pkgsArm; [
            nil
            nixfmt
            statix
          ];
        };
        ${darwinSystem}.default = pkgsDarwin.mkShell {
          packages = with pkgsDarwin; [
            nil
            nixfmt
            statix
          ];
        };
      };

      # Bootable disk images
      packages.${armSystem} = {
        dev-vm-image = self.nixosConfigurations.dev-vm.config.system.build.qcow2;
        rock5b-image = self.nixosConfigurations.radxa-rock5b-1-image.config.system.build.rawImage;
      };
    };
}
