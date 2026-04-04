# Common home-manager configuration shared across all hosts
{ pkgs, ... }:

{
  home = {
    username = "emorio";
    homeDirectory = "/home/emorio";
    stateVersion = "25.11";
  };

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    fzf
    ripgrep
    tmux
    htop
  ];
}
