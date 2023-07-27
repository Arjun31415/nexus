# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = ["ntfs"];

  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.settings = {
    builders-use-substitutes = true;
    substituters = ["https://hyprland.cachix.org" "https://anyrun.cachix.org"];
    trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
    ];
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
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.azazel = {
    isNormalUser = true;
    description = "Azazel";
    extraGroups = ["networkmanager" "wheel" "docker"];
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
    google-fonts
    python311
    nodejs
    gcc
    gnumake
    cudaPackages_12_2.cudatoolkit
    cudaPackages.cudnn
    cmake
    ninja
    rustup
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
  ];
  virtualisation.docker.enable = true;
  virtualisation.docker.storageDriver = "btrfs";
  virtualisation.oci-containers.containers = {
    hakatime = {
      image = "mujx/hakatime:latest";
      autoStart = true;
      environment = {
        HAKA_DB_HOST = "haka_db";
        HAKA_DB_PORT = "5432";
        HAKA_DB_NAME = "hakatime";
        HAKA_DB_PASS = "Admin@db";
        HAKA_DB_USER = "admin";
        HAKA_BADGE_URL = "http://localhost:8080";
        HAKA_PORT = "8080";
        HAKA_SHIELDS_IO_URL = "https://img.shields.io";
        HAKA_SESSION_EXPIRY = "24";
        HAKA_LOG_LEVEL = "info"; # Control the verbosity of the logger.
        HAKA_ENV = "dev"; # Use a json logger for production, otherwise key=value pairs.
        HAKA_HTTP_LOG = "true"; # If you want to log http requests.
      };
      ports = ["5432:8080"];
    };
    haka_db = {
      image = "postgres:12-alpine";
      environment = {
        POSTGRES_DB = "haka_db";
        POSTGRES_PASSWORD = "Admin@db";
        POSTGRES_USER = "admin";
      };
      volumes = [
        "deploy_db_data:/var/lib/postgresql/data"
      ];
    };
  };
  fonts.fonts = with pkgs; [
    (nerdfonts.override {fonts = ["FiraCode" "DroidSansMono"];})
  ];
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
    nvidiaPatches = true;
    xwayland = {
      enable = true;
      hidpi = true;
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
  services.gvfs.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.enable = true;
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
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
