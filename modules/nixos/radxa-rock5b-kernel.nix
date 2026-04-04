# Radxa ROCK 5B custom kernel (6.1.84 rk2410)
# Built from https://github.com/radxa-repo/bsp with profile rk2410
#
# This kernel includes:
# - Mali-G610 GPU driver (bifrost_kbase)
# - Panfrost driver
# - Rockchip-specific drivers and device trees
#
# To rebuild the kernel:
#   cd ../bsp
#   ./build-kernel.sh
#   # Then copy output/nixos/* to hosts/radxa-rock5b-1/kernel/
{
  config,
  lib,
  pkgs,
  ...
}:

let
  version = "6.1.84";
  localVersion = "-1-rk2410";
  modDirVersion = "${version}${localVersion}";

  # Path to pre-compiled kernel files
  kernelSrc = ../../hosts/radxa-rock5b-1/kernel;

  # Custom kernel derivation from pre-compiled files
  radxaKernelBase = pkgs.stdenvNoCC.mkDerivation {
    pname = "linux-radxa-rock5b";
    inherit version;

    src = kernelSrc;

    nativeBuildInputs = with pkgs; [ coreutils ];

    buildCommand = ''
      mkdir -p $out

      # Kernel image
      cp $src/Image $out/
      ln -s $out/Image $out/bzImage

      # Device tree
      mkdir -p $out/dtbs/rockchip
      cp $src/*.dtb $out/dtbs/rockchip/

      # Modules
      mkdir -p $out/lib/modules/${modDirVersion}
      cp -r $src/modules/${modDirVersion}/* $out/lib/modules/${modDirVersion}/

      # Fix modules source/build symlinks (point to $out instead of missing paths)
      rm -f $out/lib/modules/${modDirVersion}/source || true
      rm -f $out/lib/modules/${modDirVersion}/build || true

      # Create empty config file (some tools expect it)
      touch $out/config
    '';

    meta = with lib; {
      description = "Radxa ROCK 5B Linux kernel (RK3588)";
      homepage = "https://github.com/radxa-repo/bsp";
      license = licenses.gpl2Only;
      platforms = [ "aarch64-linux" ];
    };
  };

  # Add required passthru attributes for NixOS compatibility
  radxaKernel = radxaKernelBase.overrideAttrs (old: {
    passthru = (old.passthru or { }) // {
      inherit version modDirVersion;
      # Required by NixOS kernel module system
      kernelOlder = v: lib.versionOlder version v;
      kernelAtLeast = v: lib.versionAtLeast version v;
      isZen = false;
      isHardened = false;
      isLibre = false;
      features = {
        ia32Emulation = false;
        efiBootStub = true;
      };
      configfile = pkgs.writeText "kernel-config" "";
      config = {
        isEnabled = _: false;
        isYes = _: false;
        isNo = _: true;
        isModule = _: false;
      };
      # Critical: provide override function that returns self
      override = _: radxaKernel;
      overrideAttrs = f: radxaKernel;
    };
  });

  # Create kernel packages set using the standard function
  radxaKernelPackages = pkgs.linuxPackagesFor radxaKernel;

in
{
  options.hardware.radxa-rock5b = {
    enable = lib.mkEnableOption "Radxa ROCK 5B custom kernel and hardware support";
  };

  config = lib.mkIf config.hardware.radxa-rock5b.enable {
    # Use the custom kernel packages
    boot.kernelPackages = lib.mkForce radxaKernelPackages;

    # Point to our kernel directly
    system.boot.loader.kernelFile = "Image";

    # Required kernel modules for boot (only modules that exist in Radxa kernel)
    # Force override to prevent NixOS from adding x86-specific modules like ata_piix
    boot.initrd.availableKernelModules = lib.mkForce [
      "nvme"
      "usbhid"
      "usb_storage"
      "uas"
      "sd_mod"
      "mmc_block"
      "sdhci_of_dwcmshc" # Rockchip SD/eMMC
    ];

    # Ensure no extra modules are requested that don't exist
    boot.initrd.kernelModules = lib.mkForce [ ];

    # Don't try to build extra kernel modules (we use pre-built only)
    boot.extraModulePackages = lib.mkForce [ ];

    # Device tree configuration
    hardware.deviceTree = {
      enable = true;
      name = "rockchip/rk3588-rock-5b.dtb";
      dtbSource = "${radxaKernel}/dtbs";
    };

    # Firmware for Mali GPU
    hardware.firmware = [ pkgs.linux-firmware ];

    # Enable GPU acceleration
    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [
        mesa
      ];
    };
  };
}
