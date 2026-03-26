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

  outputs = { self, nixpkgs, home-manager, deploy-rs, ... }:
    let
      # System architectures
      x86System = "x86_64-linux";
      armSystem = "aarch64-linux";

      # Package sets for each architecture
      pkgsX86 = nixpkgs.legacyPackages.${x86System};
      pkgsArm = nixpkgs.legacyPackages.${armSystem};
    in {
      # NixOS configurations
      nixosConfigurations.thinkserver1 = nixpkgs.lib.nixosSystem {
        system = x86System;
        modules = [
          ./hosts/thinkserver1/configuration.nix
        ];
      };

      nixosConfigurations.radxa-rock5b-1 = nixpkgs.lib.nixosSystem {
        system = armSystem;
        modules = [
          ./hosts/radxa-rock5b-1/configuration.nix
        ];
      };

      # Home Manager configurations
      homeConfigurations."emorio@thinkserver1" = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgsX86;
        modules = [
          ./hosts/thinkserver1/home.nix
        ];
      };

      homeConfigurations."emorio@radxa-rock5b-1" = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgsArm;
        modules = [
          ./hosts/radxa-rock5b-1/home.nix
        ];
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
            path = deploy-rs.lib.x86_64-linux.activate.nixos
              self.nixosConfigurations.thinkserver1;
          };
        };

        radxa-rock5b-1 = {
          hostname = "192.168.2.205";
          remoteBuild = true;
          profiles.system = {
            user = "root";
            sshUser = "emorio";
            sudo = "sudo -u";
            path = deploy-rs.lib.aarch64-linux.activate.nixos
              self.nixosConfigurations.radxa-rock5b-1;
          };
        };
      };

      # Validation checks for deploy-rs
      checks = builtins.mapAttrs
        (system: deployLib: deployLib.deployChecks self.deploy)
        deploy-rs.lib;
    };
}
