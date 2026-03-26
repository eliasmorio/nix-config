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

  programs.bash = {
    enable = true;
    shellAliases = {
      # Nix shortcuts
      nr = "sudo nixos-rebuild switch --flake .#radxa-rock5b-1";
      hm = "home-manager switch --flake .#emorio@radxa-rock5b-1";
      ne = "nix eval .#nixosConfigurations.radxa-rock5b-1.config.system.build.toplevel.drvPath";

      # Git shortcuts
      gs = "git status -sb";
      ga = "git add";
      gaa = "git add .";
      gc = "git commit";
      gcm = "git commit -m";
      gl = "git log --oneline --graph --decorate -20";
      gd = "git diff";
      gdc = "git diff --cached";
      gp = "git push";
      gpl = "git pull --rebase";
    };
  };
}
