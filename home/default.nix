{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: let
  browser = ["firefox-nightly.desktop"];

  associations = {
    "text/html" = browser;
    "x-scheme-handler/http" = browser;
    "x-scheme-handler/https" = browser;
    "x-scheme-handler/ftp" = browser;
    "x-scheme-handler/about" = browser;
    "x-scheme-handler/unknown" = browser;
    "application/x-extension-htm" = browser;
    "application/x-extension-html" = browser;
    "application/x-extension-shtml" = browser;
    "application/xhtml+xml" = browser;
    "application/x-extension-xhtml" = browser;
    "application/x-extension-xht" = browser;
    "application/pdf" = "sioyek.desktop";

    "audio/*" = ["mpv.desktop"];
    "video/*" = ["mpv.dekstop"];
    "image/*" = ["imv.desktop"];
    "application/json" = browser;
    "x-scheme-handler/spotify" = ["spotify.desktop"];
    "inode/directory" = "org.kde.dolphin.desktop";
  };
in {
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "prometheus";
  home.homeDirectory = "/home/prometheus";
  home.sessionPath = ["$HOME/.cargo/bin"];
  home.activation = {
    rmSomeThing = lib.hm.dag.entryAfter ["writeBoundary"] ''
      rm -rf ~/.nix-defexpr
      rm -rf ~/.nix-profile
    '';
  };
  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.11";
  myOptions.themes.qt = {
    enable = true;
    qbittorrent-theme = {
      enable = true;
      theme-file = builtins.fetchurl {
        url = "https://github.com/catppuccin/qbittorrent/raw/main/frappe.qbtheme";
        sha256 = "00y4ykbkd2c206mfhm0k0hvfxg5dv1v1xacd6k578w2yy0yw9664";
      };
    };
    style.name = "kvantum";
    platformTheme.name = "kvantum";
    catppuccin.enable = true;
  };
  imports = [
    ./audio
    ./gtk
    ./qt
    ./torrent
    ./shells
    ./dev
    ./waybar
    ./browsers
    ./communication
    ./hyprland
    ./notifications
    ./anyrun
  ];
  home.packages = with pkgs; [
    swww
    brightnessctl
    alejandra
    p7zip
    unzip
    starship
    mcfly
    pastebinit
    mtpfs
    fastfetch
    libreoffice-fresh
    inputs.hypr-contrib.packages.${pkg.system}.grimblast
    powertop
    cliphist
    stow
    kooha
    wev
    ngrok
    imv
    hunspell
    hunspellDicts.en_US-large
    hunspellDicts.en_GB-large
    # planify
    (callPackage ./notion {})
    font-awesome
    material-symbols
    siji
    # font-manager
    evince
    kdePackages.kdenlive
    trash-cli
    eduvpn-client
    # (callPackage ./davinci-resolve {})
    # inputs.prismlauncher.packages.${pkgs.system}.prismlauncher
    prismlauncher
    # (lutris.override {
    #   extraPkgs = pkgs: [
    #     wineWowPackages.waylandFull
    #     winetricks
    #     wine-wayland
    #     # List package dependencies here
    #   ];
    # })
    # wineWowPackages.waylandFull
    # wine-wayland
    # winetricks
    # inputs.ags.packages.${pkgs.system}.default
    # openfortivpn
    # networkmanager-fortisslvpn
    networkmanagerapplet
    zapzap
    guitarix
  ];
  nixGL.packages = inputs.nixgl.packages;
  nixGL.defaultWrapper = "nvidia";
  nixGL.installScripts = ["nvidia"];
  fonts.fontconfig.enable = true;
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    extraConfig = {
      XDG_SCREENSHOTS_DIR = "${config.home.homeDirectory}/Pictures/Screenshots";
    };
  };
  xdg.mimeApps = {
    enable = true;
    associations.added = associations;
    defaultApplications = associations;
  };

  programs.btop.enable = true;
  services.kdeconnect.enable = true;
  services.kdeconnect.indicator = true;
  programs.zathura = {
    enable = true;
    extraConfig = "set selection-clipboard clipboard";
  };
  programs.sioyek.enable = true;
  services.dunst = {
    enable = true;
  };
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
