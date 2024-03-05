# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "uas" "sd_mod" "rtsx_pci_sdmmc"];
  boot.initrd.kernelModules = ["dm-snapshot"];
  boot.initrd.luks.devices."cryptroot".device = "/dev/disk/by-uuid/6398751d-6e07-4fda-b1ee-17d55967f443";
  boot.initrd.systemd.enable = true;
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];
  boot.kernelParams = [
    "mem_sleep_default=deep"
    "resume=/dev/disk/by-uuid/94f860f2-2b93-4cd4-ba5f-084d42e2761d"
    "quiet"
    "splash"
    "loglevel=3"
  ];
  boot.plymouth.enable = true;
  boot.plymouth.theme = "breeze";

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/3108a225-614d-4062-a38b-d50f08240e20";
    fsType = "btrfs";
    options = ["subvol=nix-root" "compress=zstd"];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/3108a225-614d-4062-a38b-d50f08240e20";
    fsType = "btrfs";
    options = ["subvol=@home" "compress=zstd"];
  };

  fileSystems."/home/still/.local/share/Steam/steamapps" = {
    device = "/dev/disk/by-uuid/3108a225-614d-4062-a38b-d50f08240e20";
    fsType = "btrfs";
    options = ["subvol=@steamapps" "compress=zstd"];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/3108a225-614d-4062-a38b-d50f08240e20";
    fsType = "btrfs";
    options = ["subvol=nix" "compress=zstd"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/3CD3-FBF0";
    fsType = "vfat";
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/94f860f2-2b93-4cd4-ba5f-084d42e2761d";}
  ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  # networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp59s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  services.hardware.bolt.enable = true;

  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["i915" "nvidia"]; # or "nvidiaLegacy470 etc.

  # Force S3 sleep mode. See README.wiki for details.

  # Earlier font-size setup
  console.earlySetup = true;

  # Prevent small EFI partiion from filling up
  boot.loader.systemd-boot.configurationLimit = 10;

  # Enable firmware updates via `fwupdmgr`.
  services.fwupd.enable = lib.mkDefault true;

  # This will save you money and possibly your life!
  services.thermald.enable = lib.mkDefault true;

  hardware.nvidia = {
    powerManagement = {
      # Enable NVIDIA power management.
      enable = false;

      # Enable dynamic power management.
      finegrained = false;
    };

    prime = {
      offload = {
        enable = lib.mkOverride 990 true;
        enableOffloadCmd = lib.mkIf config.hardware.nvidia.prime.offload.enable true; # Provides `nvidia-offload` command.
      };

      # Bus ID of the Intel GPU.
      intelBusId = lib.mkDefault "PCI:0:2:0";

      # Bus ID of the NVIDIA GPU.
      nvidiaBusId = lib.mkDefault "PCI:1:0:0";
    };
  };
}
