{ config, pkgs, ... }:
{
  home.username = "root";
  home.homeDirectory = "/root";

  home.stateVersion = "24.05";

  imports = [
    ../../modules/shared/home-manager.nix
  ];
}
