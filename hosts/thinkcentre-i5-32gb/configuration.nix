{ config, pkgs, ... }:
{
  imports = [
    ./home.nix
    ../../modules/linux/k3s.nix
    ../../modules/linux/home-assistant.nix
    ../../modules/linux/networking.nix
    ../../modules/linux/timezone.nix
  ];

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "yes";
    };
    extraConfig = ''
      PubkeyAcceptedKeyTypes=+ssh-ed25519
    '';
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEQdIvxwPQ8NqnaC0ssqVnu9dFA3Is66c2Me1kGeWkls"
  ];
}
