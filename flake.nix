{
  description = "NixOS and Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      nixosConfigurations.thinkserver1 = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit home-manager; };
        modules = [
          ./hosts/thinkserver1/configuration.nix
          ./modules/linux/home-assistant.nix
        ];
      };

      homeManagerConfigurations."emorio@thinkserver1" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./hosts/thinkserver1/home.nix
          ./modules/shared/home-manager.nix
        ];
      };
    };
}