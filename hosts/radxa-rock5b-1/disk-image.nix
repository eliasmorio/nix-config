# Disk image generation module for ROCK 5B
# This module configures filesystems and generates a raw image suitable for dd
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # Filesystems using labels (not UUIDs) for portability
  # Note: make-disk-image.nix uses "nixos" for root and "ESP" for boot partition
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
    autoResize = true; # Expand partition on first boot
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/ESP";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  # Enable partition growing on first boot
  boot.growPartition = true;

  # Kernel modules needed for boot
  boot.initrd.availableKernelModules = [
    "nvme"
    "usbhid"
    "uas" # USB Attached SCSI (for USB drives)
    "sd_mod" # SCSI disk support
  ];

  # Platform
  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

  # Generate raw disk image using nixpkgs make-disk-image
  system.build.rawImage = import (pkgs.path + "/nixos/lib/make-disk-image.nix") {
    inherit lib config pkgs;
    diskSize = "auto";
    format = "raw";
    partitionTableType = "efi";
    # Root partition label (boot/ESP is automatically labeled "ESP")
    label = "nixos";
    # Additional space for nix store growth
    additionalSpace = "2G";
  };
}
