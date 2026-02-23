{
  description = "Home Manager configuration for NixOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      user = "emorio";
      email = "emorio@users.noreply.github.com";
      linuxSystem = "x86_64-linux";
      linuxPkgs = nixpkgs.legacyPackages.${linuxSystem};
    in {
      nixosConfigurations.thinkcentre-i5-32gb = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./hosts/thinkcentre-i5-32gb/configuration.nix ];
      };

      homeConfigurations."root@thinkcentre-i5-32gb" = home-manager.lib.homeManagerConfiguration {
        pkgs = linuxPkgs;
        extraSpecialArgs = { inherit user email; };
        modules = [ ./hosts/thinkcentre-i5-32gb/home.nix ];
      };
    };
}
