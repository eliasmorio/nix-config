# Radxa Rock 5B configuration
{
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/common.nix
    ../../modules/nixos/locale-fr.nix
    ../../modules/nixos/users/emorio.nix
    ../../modules/nixos/ssh-server.nix
    ../../modules/nixos/node-exporter.nix
    # ../../modules/nixos/radxa-rock5b-kernel.nix
    # ../../modules/k3s-single.nix
  ];

  # Use latest mainline kernel (matches working /etc/nixos config)
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Bootloader (kernel is configured via radxa-rock5b-kernel module)
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Networking with static IP
  networking = {
    hostName = "radxa-rock5b-1";
    useDHCP = false;

    interfaces.enP4p65s0.ipv4.addresses = [
      {
        address = "192.168.2.205";
        prefixLength = 24;
      }
    ];

    defaultGateway = "192.168.2.254";
    nameservers = [ "192.168.2.202" ];
  };

  # Host-specific: add networkmanager group
  users.users.emorio.extraGroups = lib.mkAfter [ "networkmanager" ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Host-specific packages
  environment.systemPackages = with pkgs; [
    home-manager
    # Kernel module development
    gnumake
    gcc
    binutils
    pkg-config
  ];

  # Enable NTP time synchronization (Rock 5B has no battery-backed RTC)
  services.timesyncd.enable = true;

  # Create /usr/lib/modules for systemd namespace sandboxing compatibility
  systemd.tmpfiles.rules = [
    "d /usr/lib/modules 0755 root root -"
  ];

  system.stateVersion = "25.11";
}
