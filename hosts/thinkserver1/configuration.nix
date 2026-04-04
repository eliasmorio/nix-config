# thinkserver1 NixOS configuration
{
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/common.nix
    ../../modules/nixos/users/emorio.nix
    ../../modules/nixos/ssh-server.nix
    ../../modules/k3s.nix
    ../../modules/cloudflared.nix
  ];

  # Bootloader
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Networking with static IP
  networking = {
    hostName = "thinkserver1";
    useDHCP = false;

    interfaces.enp0s31f6.ipv4.addresses = [
      {
        address = "192.168.2.201";
        prefixLength = 24;
      }
    ];

    defaultGateway = "192.168.2.254";
    nameservers = [ "192.168.2.202" ];

    # Firewall
    firewall.allowedTCPPorts = [
      80
      443
    ];
  };

  # Host-specific: add networkmanager group
  users.users.emorio.extraGroups = lib.mkAfter [ "networkmanager" ];

  # Host-specific packages (home-manager is now integrated)
  environment.systemPackages = with pkgs; [
    home-manager
  ];

  system.stateVersion = "25.11";
}
