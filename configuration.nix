{
  config,
  pkgs,
  inputs,
  lib,
  system,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];
  environment.etc."greetd/environments".text = ''
    sway
    fish
    bash
    gnome
    gtk
  '';
  services.cpupower-gui.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.dbus.enable = true;
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
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    TERMINAL = "kitty";
    TERM = "kitty";
  };
  nixpkgs.config.permittedInsecurePackages = [
    "mailspring-1.11.0"
  ];
  nix.settings.auto-optimise-store = true;
  nix.registry = lib.mapAttrs (_: v: {flake = v;}) inputs;
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.settings = {
    keep-derivations = true;
    builders-use-substitutes = true;
    substituters = [
      "https://hyprland.cachix.org"
      "https://anyrun.cachix.org"
      "https://nixpkgs-wayland.cachix.org"
      "https://viperml.cachix.org"
      "https://cache.garnix.io"
    ];
    trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
      "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "viperml.cachix.org-1:qZhKBMTfmcLL+OG6fj/hzsMEedgKvZVFRRAhq7j8Vh8="
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
    ];
  };

  networking.hostName = "Omen"; # Define your hostname.
  # Enable networking
  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;
  networking.nameservers = ["1.1.1.1" "9.9.9.9"];

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
    enable = true;
    layout = "us";
    xkbVariant = "";
    libinput = {
      enable = true;
    };
    excludePackages = [pkgs.xterm];
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
  services.tlp = {
    enable = true;
    settings = {
      START_CHARGE_THRESH_BAT0 = 75;
      STOP_CHARGE_THRESH_BAT0 = 80;
    };
  };
  services.auto-cpufreq.enable = true;
  services.printing.enable = true;
  services.printing.drivers = [pkgs.epson-escpr];

  services.avahi.enable = true;
  services.avahi.nssmdns = true;
  services.avahi.openFirewall = true;

  environment.systemPackages = with pkgs; [
    config.boot.kernelPackages.cpupower
    compsize
    wget
    ripgrep
    jaq
    eza
    bat
    kitty
    wezterm
    dunst
    nvtop
    git
    git-lfs
    firefox
    glib
    glib-networking
    pciutils
    pavucontrol
    nodejs
    gcc
    gnumake
    xfce.exo
    nix-output-monitor
    # cudaPackages_12_2.cudatoolkit
    # cudaPackages.cudnn
    xdg-desktop-portal-hyprland
    gcc-unwrapped.lib
    rocmPackages.llvm.clang-unwrapped
    xdg-utils
    wl-clipboard
    inxi
    playerctl
    libnotify
    dex
    tree
    killall
    xorg.xeyes
    inputs.nixpkgs-wayland.packages.${system}.swaylock-effects
    inputs.nh.packages.${system}.default
    cinnamon.nemo-with-extensions
    # cpupower-gui
  ];
  security.pam.services.swaylock = {};

  virtualisation.docker.enable = true;
  virtualisation.docker.storageDriver = "btrfs";
  virtualisation.docker.enableNvidia = true;
  fonts.packages = with pkgs; [
    (nerdfonts.override {fonts = ["FiraCode" "DroidSansMono" "JetBrainsMono"];})
    google-fonts
    material-design-icons
    liberation_ttf
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    corefonts
  ];
  programs.dconf.enable = true;
  programs.xfconf.enable = true;
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

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --remember-session --user-menu --time --cmd Hyprland";
        user = "greeter";
      };
    };
  };
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
  services.tumbler.enable = true;

  services.gvfs.enable = true;
  services.lidarr = {
    enable = true;
    group = "media";
  };
  services.sonarr = {
    enable = true;
    group = "media";
  };

  services.radarr = {
    enable = true;
    group = "media";
  };
  services.bazarr.enable = true;
  services.prowlarr.enable = true;
  systemd.tmpfiles.rules = [
    "d /shared-torents/Downloads 0770 lidarr media - -"
  ];
  services.readarr.enable = true;
  users.groups.media.members = ["radarr" "sonarr" "lidarr" "bazarr" "prowlarr" "prometheus"];
  programs.sway.enable = true;

  # started in user sessions.
  # programs.mtr.enable = truqe;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  networking.firewall = {
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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
