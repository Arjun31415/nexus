# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
with lib; let
  nvStable = config.boot.kernelPackages.nvidiaPackages.stable.version;
  nvBeta = config.boot.kernelPackages.nvidiaPackages.beta.version;
  nvidiaPackage =
    if (versionOlder nvBeta nvStable)
    then config.boot.kernelPackages.nvidiaPackages.stable
    else config.boot.kernelPackages.nvidiaPackages.beta;
in {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "nvme" "ahci" "usb_storage" "sd_mod" "sdhci_pci"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-amd" "acpi_call"];
  boot.extraModulePackages = with config.boot.kernelPackages; [acpi_call];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/ecbac740-efa1-43ce-9380-4d8c1ab7d519";
    fsType = "btrfs";
    options = ["subvol=@"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/7A76-218F";
    fsType = "vfat";
  };
  fileSystems."/mnt/shared" = {
    device = "/dev/disk/by-label/Shared";
    fsType = "ntfs";
    options = ["defaults" "uid=1000" "gid=989" "rw"];
  };

  swapDevices = [];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  boot = {
    # blacklist nouveau module so that it does not conflict with nvidia drm stuff
    # also the nouveau performance is godawful, I'd rather run linux on a piece of paper than use nouveau
    blacklistedKernelModules = ["nouveau"];
  };
  time.hardwareClockInLocalTime = true;
  services.xserver.videoDrivers = ["nvidia"];
  programs.xwayland.enable = true;
  hardware = {
    enableAllFirmware = true;
    nvidia = {
      package = mkDefault nvidiaPackage;
      modesetting.enable = true;
      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        #  sync.enable = true;
        nvidiaBusId = "PCI:1:0:0";
        amdgpuBusId = "PCI:6:0:0";
      };
      powerManagement = {
        enable = true;
        finegrained = true;
      };
      open = true;
      nvidiaSettings = false; # add nvidia-settings to pkgs, useless on nixos
      #      nvidiaPersistenced = true;
      forceFullCompositionPipeline = true;
    };

    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        nvidia-vaapi-driver

        libva
        libva-utils
        vaapiVdpau
      ];
      extraPackages32 = with pkgs.pkgsi686Linux; [nvidia-vaapi-driver];
    };
  };
}
