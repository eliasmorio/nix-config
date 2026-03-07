{ config, pkgs, ... }:
{
  home.username = "emorio";
  home.homeDirectory = "/home/emorio";
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    fzf
    ripgrep
    tmux
    htop
  ];

  programs.git = {
    enable = true;
    settings.user = {
      name = "eliasmorio";
      email = "eliasmorio@users.noreply.github.com";
    };
  };

  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
    };
  };
}
