# Do not modify this file!  It was generated by ‘nixos-generate-config’blackl
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
  boot = {
    initrd = {
      availableKernelModules = ["xhci_pci" "nvme" "ahci" "usb_storage" "sd_mod" "sdhci_pci"];
      kernelModules = ["kvm-amd" "acpi_call" "hp-wmi"];
    };
    extraModulePackages = with config.boot.kernelPackages; [acpi_call];
    # blacklist nouveau module so that it does not conflict with nvidia drm stuff
    blacklistedKernelModules = ["nouveau"];
    kernelParams = [
      "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
      "amd_pstate=passive"
    ];
  };

  services.rpcbind.enable = true; # needed for NFS
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/ecbac740-efa1-43ce-9380-4d8c1ab7d519";
    fsType = "btrfs";
    options = ["subvol=@" "compress=zstd"];
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
  fileSystems."/mnt/nfs-shared" = {
    device = "192.168.1.120:/nfs-shared";
    fsType = "nfs";
    options = ["noauto" "noatime" "nodiratime"];
  };
  services.btrfs.autoScrub.enable = true;
  services.btrfs.autoScrub.interval = "weekly";

  swapDevices = [
    {
      device = "/swap/swapfile";
      size = 1024 * 8; # RAM size/2
    }
  ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;

  nix.settings.system-features = ["benchmark" "big-parallel" "kvm" "nixos-test" "gccarch-znver2"];

  programs.corectrl.enable = true;
  time.hardwareClockInLocalTime = false;
  services.xserver.videoDrivers = ["nvidia"];
  programs.xwayland.enable = true;
  programs.ryzen-monitor-ng.enable = true;
  hardware.enableRedistributableFirmware = true;
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.settings = {
    General = {
      Experimental = true;
    };
  };
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  hardware = {
    cpu.amd = {
      ryzen-smu = {enable = true;};
      updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
    enableAllFirmware = true;
    nvidia = {
      package = mkDefault config.boot.kernelPackages.nvidiaPackages.beta;
      modesetting.enable = true;
      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        nvidiaBusId = "PCI:1:0:0";
        amdgpuBusId = "PCI:6:0:0";
      };
      powerManagement = {
        enable = true;
        finegrained = true;
      };
      open = false;
      nvidiaSettings = false; # add nvidia-settings to pkgs, useless on nixos
      forceFullCompositionPipeline = true;
    };

    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        nvidia-vaapi-driver
        libva
        libva-utils
        vaapiVdpau
        vulkan-loader
      ];
      extraPackages32 = with pkgs.pkgsi686Linux; [nvidia-vaapi-driver];
    };
  };
}
