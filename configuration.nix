{
  pkgs,
  inputs,
  lib,
  system,
  options,
  ...
}: let
  hyprlandSuspendScript = pkgs.writeShellScript "suspend-hyprland.sh" ''
    case "$1" in
        suspend)
            killall -STOP Hyprland
            ;;
        resume)
            killall -CONT Hyprland
            ;;
    esac
  '';
  # kernel_pkg = pkgs.linuxPackages_latest;
  kernel_pkg = pkgs.linuxPackages_6_13;
in {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    ./modules/amdctl
  ];
  environment.etc."greetd/environments".text = ''
    sway
    fish
    bash
    gnome
    gtk
  '';
  boot = {
    kernelPackages = kernel_pkg;
    # boot.tmp.cleanOnBoot = true;
    # Bootloader.
    loader.systemd-boot.enable = false;
    loader.grub = {
      useOSProber = true;
      configurationLimit = 10;
      enable = true;
      device = "nodev";
      efiSupport = true;
    };
    loader.efi.canTouchEfiVariables = true;
    supportedFilesystems = ["ntfs"];
    kernel.sysctl."fs.inotify.max_user_watches" = 100000;
  };
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    TERMINAL = "kitty";
    TERM = "kitty";
  };
  nix.settings = {
    # nix.registry = lib.mapAttrs (_: v: {flake = v;}) inputs;
    trusted-users = ["root" "@wheel"];
    experimental-features = ["nix-command" "flakes"];
    auto-optimise-store = true;
    keep-derivations = false;
    builders-use-substitutes = true;
    substituters = [
      "https://hyprland.cachix.org"
      "https://anyrun.cachix.org"
      "https://nixpkgs-wayland.cachix.org"
      "https://viperml.cachix.org"
      "https://cache.garnix.io"
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://nixpkgs-wayland.cachix.org"
      "https://prismlauncher.cachix.org"
    ];
    trusted-public-keys = [
      "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
      "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "viperml.cachix.org-1:qZhKBMTfmcLL+OG6fj/hzsMEedgKvZVFRRAhq7j8Vh8="
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "prismlauncher.cachix.org-1:9/n/FGyABA2jLUVfY+DEp4hKds/rwO+SCOtbOkDzd+c="
    ];
  };

  networking = {
    hostName = "omen"; # Define your hostname.
    # Enable networking
    networkmanager.enable = true;
    nameservers = ["1.1.1.1" "9.9.9.9"];
  };

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # time.timeZone = "Asia/Calcutta";
  networking.timeServers = options.networking.timeServers.default;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_IN";

  programs.obs-studio.enable = true;
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
  services = {
    # automatic-timezoned.enable=true;
    # localtime.enable = true;
    # geoclue2={enable = true; enableWifi=false;};
    hardware.openrgb.enable = true;
    udev.extraRules = ''
      SUBSYSTEMS=="usb", ACTION=="add", GROUP="usb", MODE="0664"
    '';
    gnome = {
      gnome-keyring.enable = true;
      # gnome-online-accounts.enable = true;
      # evolution-data-server.enable = true;
    };
    dbus.enable = true;
    blueman.enable = true;
    printing.enable = true;
    printing.drivers = [pkgs.epson-escpr];
    avahi.enable = true;
    avahi.nssmdns4 = true;
    avahi.openFirewall = true;
    tlp = {
      enable = true;
      settings = {
        START_CHARGE_THRESH_BAT0 = 75;
        STOP_CHARGE_THRESH_BAT0 = 80;
      };
    };
    # services.greetd = {
    #   enable = true;
    #   settings = {
    #     default_session = {
    #       command = "${pkgs.greetd.tuigreet}/bin/tuigreet --remember-session --user-menu --time --cmd Hyprland";
    #       user = "greeter";
    #     };
    #   };
    # };
    libinput = {
      enable = true;
    };
    displayManager.sddm = {
      enable = true;
      theme = "tokyo-night-sddm";
      wayland.enable = true;
    };

    xserver = {
      enable = true;
      xkb.layout = "us";
      xkb.variant = "";
      excludePackages = [pkgs.xterm];
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      audio.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;
    };

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
    # programs.thunar = {
    #   enable = true;
    #   plugins = with pkgs.xfce; [
    #     thunar-archive-plugin
    #     thunar-volman
    #     thunar-media-tags-plugin
    #   ];
    # };
    tumbler.enable = true;
    #deluge = {
    #   enable = true;
    #   group = "media";
    #   web = {
    #     enable = true;
    #     port = 8112;
    #   };
    # };
    gvfs = {
      enable = true;
    };
    # started in user sessions.
    # programs.mtr.enable = truqe;
    # programs.gnupg.agent = {
    #   enable = true;
    #   enableSSHSupport = true;
    # };

    # List services that you want to enable:

    # Enable the OpenSSH daemon.
    openssh.enable = true;
    postgresql = {
      enable = true;
      ensureDatabases = ["mydatabase"];
      authentication = pkgs.lib.mkOverride 10 ''
        #type database  DBuser  auth-method
        local all       all     trust
      '';
    };
  };

  environment.systemPackages = with pkgs; [
    (libsForQt5.callPackage ./tokyo-night-sddm.nix {})
    # (linuxKernel.packagesFor (kernel.override {
    #   stdenv = gcc12Stdenv;
    #   buildPackages = pkgs.buildPackages // {stdenv = gcc12Stdenv;};
    # }))
    # .perf
    kernel_pkg.perf
    fswatch
    wget
    fd
    ripgrep
    jaq
    eza
    bat
    kitty
    dunst
    nvtopPackages.full
    git
    git-lfs
    glib
    glib-networking
    pciutils
    pwvucontrol
    nodejs
    gcc
    gnumake
    nix-output-monitor
    gcc-unwrapped.lib
    xdg-utils
    wl-clipboard
    inxi
    playerctl
    libnotify
    dex
    tree
    killall
    xorg.xeyes
    inputs.nh.packages.${system}.default
    inputs.zen-browser.packages.${pkgs.system}.default
    plasma5Packages.dolphin
    plasma5Packages.dolphin-plugins
    plasma5Packages.kio
    plasma5Packages.kio-extras
    plasma5Packages.kimageformats
    plasma5Packages.kdegraphics-thumbnailers
    plasma5Packages.kio-admin
    kio-fuse
    waypipe
    # disk space reporting tool
    duc
    wayvnc
  ];
  virtualisation = {
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
  };
  # services.accounts-daemon.enable = true;
  # virtualisation.docker.enable = true;
  # virtualisation.docker.storageDriver = "btrfs";
  # virtualisation.docker.enableNvidia = true;
  programs = {
    virt-manager.enable = true;
    dconf.enable = true;
    xfconf.enable = true;
    fish.enable = true;
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      portalPackage = inputs.xdph.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
      xwayland = {
        enable = true;
      };
    };
    sway.enable = true;
    noisetorch.enable = true;
  };
  # virtualisation.vmware.host.enable = true;
  fonts.packages = with pkgs; [
    # (nerdfonts.override {fonts = ["FiraCode" "DroidSansMono" "JetBrainsMono"];})
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
    nerd-fonts.jetbrains-mono
    google-fonts
    material-design-icons
    liberation_ttf
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    corefonts
    monaspace
  ];
  security = {
    pam.services = {
      hyprlock = {};
      greetd.enableGnomeKeyring = true;
    };
    wrappers."mount.nfs" = {
      setuid = true;
      owner = "root";
      group = "root";
      source = "${pkgs.nfs-utils.out}/bin/mount.nfs";
    };
    wrappers.samply = {
      source = "${pkgs.samply}/bin/samply";
      capabilities = "cap_perfmon+ep";
      owner = "root";
      group = "media";
    };
    rtkit.enable = true;
    polkit = {
      enable = true;
      extraConfig = ''
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
    };
  };
  systemd = {
    services = {
      NetworkManager-wait-online.enable = false;
      "hyprland-resume" = {
        description = "Resume hyprland";
        unitConfig = {
          After = [
            "systemd-suspend.service"
            "systemd-hibernate.service"
            "nvidia-suspend.service"
          ];
        };
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${hyprlandSuspendScript} resume";
        };
        wantedBy = ["systemd-suspend.service" "systemd-hibernate.service"];
      };
      "hyprland-suspend" = {
        description = "Suspend Hyprland";
        unitConfig = {
          Before = [
            "systemd-suspend.service"
            "systemd-hibernate.service"
            "nvidia-suspend.service"
            "nvidia-hibernate.service"
          ];
        };
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${hyprlandSuspendScript} suspend";
        };
        wantedBy = ["systemd-suspend.service" "systemd-hibernate.service"];
      };
    };

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
    tmpfiles.rules = [
      "d /shared-torents/Downloads 0770 lidarr media - -"
    ];
  };
  xdg.autostart.enable = true;
  xdg.portal = {
    wlr.enable = lib.mkForce true;
    enable = true;
    extraPortals = [
      pkgs.libsForQt5.xdg-desktop-portal-kde
    ];
  };
  users = {
    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.prometheus = {
      isNormalUser = true;
      description = "Prometheus";
      extraGroups = ["networkmanager" "wheel" "docker" "prometheus" "input" "samply" "usb" "libvirtd"];
      shell = pkgs.fish;
    };
    groups.libvirtd.members = ["prometheus"];
    groups.media.members = ["radarr" "sonarr" "lidarr" "bazarr" "prowlarr" "prometheus"];
    groups.usb.members = ["prometheus"];
  };
  services.tailscale.enable = true;
  # services.lidarr = {
  #   enable = true;
  #   group = "media";
  # };
  # services.sonarr = {
  #   enable = true;
  #   group = "media";
  # };
  #
  # services.radarr = {
  #   enable = true;
  #   group = "media";
  # };
  # services.bazarr.enable = true;
  # services.prowlarr.enable = true;
  # services.readarr.enable = true;
  # services.pgadmin.enable = true;
  # services.undervolt.amdctl = {
  #   enable = true;
  #   mode = "inc";
  #   pstateVoltages = [143 100 62];
  # };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  networking.firewall = {
    checkReversePath = false;
    trustedInterfaces = ["virbr0"];
    enable = true;
    allowedTCPPortRanges = [
      {
        from = 1714;
        to = 1764;
      } # KDE Connect
    ];
    allowedUDPPortRanges = [
      {
        from = 1714;
        to = 1764;
      } # KDE Connect
    ];
  };
  # https://github.com/NixOS/nixpkgs/issues/24913
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
