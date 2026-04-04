# Radxa ROCK 5B - Configuration for flashable disk image
# This configuration is used to generate a raw image that can be dd'd to NVMe
#
# Key differences from regular configuration.nix:
# - Uses extlinux bootloader (U-Boot compatible) instead of systemd-boot
# - Filesystems by label instead of UUID
# - IP address: 192.168.2.210
#
{ lib, pkgs, ... }:

{
  imports = [
    ./disk-image.nix
    ../../modules/nixos/common.nix
    ../../modules/nixos/locale-fr.nix
    ../../modules/nixos/users/emorio.nix
    ../../modules/nixos/ssh-server.nix
    ../../modules/nixos/radxa-rock5b-kernel.nix
  ];

  # Enable Radxa ROCK 5B custom kernel with Mali GPU support
  hardware.radxa-rock5b.enable = true;

  # Bootloader: extlinux (compatible with U-Boot on ROCK 5B)
  # Do NOT use systemd-boot or GRUB - they don't work with U-Boot
  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  # Networking with static IP
  networking = {
    hostName = "radxa-rock5b-1";
    useDHCP = false;

    interfaces.enP4p65s0.ipv4.addresses = [
      {
        address = "192.168.2.210";
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
