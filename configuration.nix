# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: let
  greetdHyprlandConfig = pkgs.writeText "greetd-hyprland-config" ''
    env = GBM_BACKEND,nvidia
    env = MOZ_ENABLE_WAYLAND,1
    env = LIBVA_DRIVER_NAME,nvidia
    env = XDG_SESSION_TYPE,wayland
    env = __GLX_VENDOR_LIBRARY_NAME,nvidia
    env = WLR_NO_HARDWARE_CURSORS,1

    exec-once = ${lib.getExe config.programs.regreet.package} -l debug; hyprctl dispatch exit
    exec = dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP

    animations {
      enabled = no
    }
    decoration {
      drop_shadow = no;
      rounding = 0;
      blur {
        enabled = no;
      }
    }
    general {
      gaps_in = 0;
      gaps_out = 0;
      border_size = 1;
    }
  '';
  /*
     nixos-boot-src = pkgs.fetchFromGitHub {
    owner = "Melkor333";
    repo = "nixos-boot";
    rev = "main";
    sha256 = "sha256-kcYd39n58MVI2mFn/PSh5O/Wzr15kEYWgszMRtSQ+1w=";
  };
  */
  # define the theme you want to use
  #  nixos-boot = pkgs.callPackage nixos-boot-src {};
  # You might want to override the theme
  #nixos-boot = pkgs.callPackage nixos-boot-src {
  #  bgColor = "0.1, 1, 0.8"; # Weird 0-1 range RGB. In this example roughly mint
  #  theme = "load_unload";
  #};
in {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];
  /*
     boot.plymouth = {
    enable = true;
    themePackages = [nixos-boot];
    theme = "load_unload";
  };
  */
  services.gnome.gnome-keyring.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  # Bootloader.
  boot.loader.systemd-boot.enable = false;
  boot.loader.grub = {
    useOSProber = true;
    configurationLimit = 10;
    enable = true;
    device = "nodev";
    efiSupport = true;
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = ["ntfs"];
  /*
     boot.plymouth.enable = true;
  boot.plymouth.theme = "breeze";
  */
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  nix.settings.auto-optimise-store = true;
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.settings = {
    builders-use-substitutes = true;
    substituters = ["https://hyprland.cachix.org" "https://anyrun.cachix.org"];
    trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
    ];
    keep-outputs = true;
    keep-derivations = true;
  };

  networking.hostName = "Omen"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_IN";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
    libinput = {
      enable = true;
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.prometheus = {
    isNormalUser = true;
    description = "Prometheus";
    extraGroups = ["networkmanager" "wheel" "docker" "prometheus" "input"];
    shell = pkgs.fish;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    ripgrep
    exa
    bat
    kitty
    dunst
    nvtop
    git
    git-lfs
    firefox
    pciutils
    pavucontrol
    nodejs
    gcc
    gnumake
    cudaPackages_12_2.cudatoolkit
    cudaPackages.cudnn
    cmake
    ninja
    xdg-desktop-portal-hyprland
    gcc-unwrapped.lib
    llvmPackages_rocm.clang-unwrapped
    xdg-utils
    wl-clipboard
    inxi
    playerctl
    libnotify
    dex
    tree
    killall
    xorg.xeyes
    swaylock-effects
    #    libsecret
  ];
  security.pam.services.swaylock = {};

  #  services.gnome.gnome-keyring.enable = true;
  #  programs.regreet.enable = true;
  virtualisation.docker.enable = true;
  virtualisation.docker.storageDriver = "btrfs";
  virtualisation.oci-containers.containers = {
    flaresolverr = {
      autoStart = true;
      image = "ghcr.io/flaresolverr/flaresolverr:latest";
      environment = {
        LOG_LEVEL = "info";
        LOG_HTML = "false";
        CAPTCHA_SOLVER = "none";
      };
      ports = ["8191:8191"];
    };
  };
  fonts.packages = with pkgs; [
    (nerdfonts.override {fonts = ["FiraCode" "DroidSansMono" "JetBrainsMono"];})
    google-fonts
    material-design-icons
  ];
  programs.dconf.enable = true;

  programs.fish.enable = true;
  security.rtkit.enable = true;
  security.polkit.enable = true;
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (
        subject.isInGroup("users")
          && (
            action.id == "org.freedesktop.login1.reboot" ||
            action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
            action.id == "org.freedesktop.login1.power-off" ||
            action.id == "org.freedesktop.login1.power-off-multiple-sessions" ||
          )
        )
      {
        return polkit.Result.YES;
      }
    })
  '';
  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = ["graphical-session.target"];
      wants = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  /*
     services.greetd = {
    enable = true;
  };
  */
  #  services.greetd.settings.default_session.command = "Hyprland --config ${greetdHyprlandConfig}";
  #  services.greetd.settings.default_session.command = "dbus-run-session cage -s  -- ${lib.getExe config.programs.regreet.package}";
  security.pam.services.greetd.enableGnomeKeyring = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    audio.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    enableNvidiaPatches = true;
    xwayland = {
      enable = true;
    };
  };

  /*
     networking.extraHosts = ''
  ''
  */
  # to boot onto external monitor
  /*
     specialisation = {
    external-display.configuration = {
      system.nixos.tags = ["external-display"];
      hardware.nvidia = {
        prime.offload.enable = lib.mkForce false;
        powerManagement.enable = lib.mkForce false;
      };
    };
  };
  */
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
    ];
  };
  services.tumbler.enable = true;

  services.gvfs.enable = true;
  services.lidarr = {
    enable = true;
    group = "media";
  };

  services.radarr.enable = true;
  services.radarr.group = "media";
  services.bazarr.enable = true;
  services.prowlarr.enable = true;
  systemd.tmpfiles.rules = [
    "d /shared-torents/Downloads 0770 lidarr media - -"
  ];
  services.readarr.enable = true;
  users.groups.media.members = ["radarr" "sonarr" "lidarr" "bazarr" "prowlarr" "prometheus"];
  services.xserver.displayManager.lightdm = {
    enable = true;
  };
  services.xserver.displayManager.defaultSession = "hyprland";

  services.xserver.enable = true;
  #  services.xserver.displayManager.sddm.enable = true;
  # services.xserver.enable = true;
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = truqe;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
