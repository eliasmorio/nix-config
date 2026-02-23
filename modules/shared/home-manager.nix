{ config, pkgs, ... }:
{
  home.stateVersion = "25.11";

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
  };

  editorconfig.enable = true;

  xdg.enable = true;
}