# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:
with lib; let
  nvStable = config.boot.kernelPackages.nvidiaPackages.stable.version;
  nvBeta = config.boot.kernelPackages.nvidiaPackages.beta.version;
#  nvidiaPackage =
 #   if (versionOlder nvBeta nvStable)
#    then config.boot.kernelPackages.nvidiaPackages.stable
#    else config.boot.kernelPackages.nvidiaPackages.beta;
 nvidiaPackage = config.boot.kernelPackages.nvidiaPackages.beta;
in {
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "ahci" "usb_storage" "sd_mod" "sdhci_pci" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/85e87b52-ae20-4d6a-b61d-971c9642fd93";
      fsType = "btrfs";
      options = [ "subvol=@" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/C6BE-1DCB";
      fsType = "vfat";
    };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno1.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlo1.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  boot = {
      # blacklist nouveau module so that it does not conflict with nvidia drm stuff
      # also the nouveau performance is godawful, I'd rather run linux on a piece of paper than use nouveau
      blacklistedKernelModules = ["nouveau"];
    };
  environment = {
    sessionVariables = mkMerge [
      {
	LIBVA_DRIVER_NAME = "nvidia";
      }
      {
	WLR_NO_HARDWARE_CURSORS = "1";
      }
    ];
 systemPackages = with pkgs; [
        vulkan-tools
        vulkan-loader
        vulkan-validation-layers
        libva
        libva-utils
      ];
  };
  services.xserver.videoDrivers = ["nvidia"];
  programs.xwayland.enable = true;
  hardware = {
      nvidia = {
        package = mkDefault nvidiaPackage;
        modesetting.enable = mkDefault true;
        prime = {
	  offload = {
	    enable = true;
 	    enableOffloadCmd = true;
          };
	  nvidiaBusId = "PCI:1:0:0";
          amdgpuBusId = "PCI:6:0:0";
        };
        powerManagement = {
          enable = mkDefault true;
          finegrained = mkDefault true;
        };

        # use open source drivers by default, hosts may override this option if their gpu is
        # not supported by the open source drivers
        open = mkDefault true;
        nvidiaSettings = false; # add nvidia-settings to pkgs, useless on nixos
        nvidiaPersistenced = true;
        forceFullCompositionPipeline = true;
      };

      opengl = {
        extraPackages = with pkgs; [nvidia-vaapi-driver];
#        extraPackages32 = with pkgs.pkgsi686Linux; [nvidia-vaapi-driver];
      };
    };

#  hardware.opengl = {
 #   enable = true;
 #   driSupport = true;
 #   driSupport32Bit = true;
 # };
  
#  services.xserver.displayManager.gdm.wayland = true;
#  services.xserver.displayManager.gdm.nvidiaWayland = true;
  
}
