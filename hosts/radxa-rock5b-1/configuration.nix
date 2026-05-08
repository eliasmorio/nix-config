# radxa-rock5b-1 NixOS configuration
{ lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/common.nix
    ../../modules/nixos/users/emorio.nix
    ../../modules/nixos/ssh-server.nix
    ../../modules/k3s-agent.nix
  ];

  boot = {
    # Bootloader
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    # Use latest kernel
    kernelPackages = pkgs.linuxPackages_latest;
  };

  # Networking with static IP
  networking = {
    hostName = "radxa-rock5b-1";
    useDHCP = false;
    networkmanager.enable = true;

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

  # Locale
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  # Keyboard layout
  services.xserver.xkb = {
    layout = "fr";
    variant = "";
  };

  console.keyMap = "fr";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "25.11";
}
