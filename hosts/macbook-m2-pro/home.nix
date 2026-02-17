{ config, pkgs, user, email, ... }:
{
  home.username = user;
  home.homeDirectory = "/Users/emorio";

  home.stateVersion = "24.05";

  imports = [
    ../../modules/shared/home-manager.nix
    ../../modules/darwin/packages.nix
  ];
}
