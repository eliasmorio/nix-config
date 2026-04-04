# Common NixOS settings shared across all hosts
{ lib, pkgs, ... }:

{
  # Nix settings
  nix = {
    settings = {
      # Enable flakes and new nix command
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      # Optimize nix store automatically
      auto-optimise-store = true;
      # Allow wheel users to use nix
      trusted-users = [
        "root"
        "@wheel"
      ];
    };
    # Automatic garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  # Timezone
  time.timeZone = "Europe/Paris";

  # Base system packages available on all hosts
  environment.systemPackages = with pkgs; [
    vim
    git
    htop
    tmux
    wget
    tree
  ];
}
