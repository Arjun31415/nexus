# Hate that I have to thank this doood : https://codeberg.org/jacekpoz/niksos/src/branch/master/modules/gui/qt.nix
{
  config,
  pkgs,
  lib,
  impurity,
  ...
}: let
  scheme = "catppuccin";
  cfg = config.myOptions.themes.qt;
  theme-package = pkgs.catppuccin-kde.override {
    flavour = ["mocha"];
    accents = ["maroon"];
  };
in {
  options.myOptions.themes.qt = {
    enable = lib.mkEnableOption "enable qt theming";
  };

  config = lib.mkIf cfg.enable {
    qt = {
      enable = true;
      style = {
        name = "Catppuccin-Mocha-Dark";
        package = theme-package;
      };
    };
    home = {
      packages = with pkgs; [
        qt5.qttools
        qt6Packages.qtstyleplugin-kvantum
        libsForQt5.qtstyleplugin-kvantum
        libsForQt5.qt5ct
        qt6Packages.qt6ct
        breeze-icons
      ];

      sessionVariables = {
        # increase priority
        QT_STYLE_OVERRIDE = lib.mkForce "kvantum";
        QT_AUTO_SCREEN_SCALE_FACTOR = "1";
        QT_QPA_PLATFORM = "wayland;xcb";
        # QT_QPA_PLATFORMTHEME = "qt5ct";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        DISABLE_QT_COMPAT = "0";
      };
    };
    xdg.configFile = {
      "qBittorrent/themes/catppuccin.qbtheme".source = builtins.fetchurl {
        url = "https://github.com/catppuccin/qbittorrent/raw/main/frappe.qbtheme";
        sha256 = "00y4ykbkd2c206mfhm0k0hvfxg5dv1v1xacd6k578w2yy0yw9664";
      };
      "kdeglobals".source = impurity.link ./kdeglobals;
      "Kvantum/${scheme}/${scheme}.kvconfig".source = builtins.fetchurl {
        url = "https://raw.githubusercontent.com/catppuccin/Kvantum/main/src/Catppuccin-Mocha-Maroon/Catppuccin-Mocha-Maroon.kvconfig";
        sha256 = "15gzp8vdy8l6cmkbn89gdi5z8j2my2q3r6gbhi8as9b8aqw9wa27";
      };
      "Kvantum/${scheme}/${scheme}.svg".source = builtins.fetchurl {
        url = "https://raw.githubusercontent.com/catppuccin/Kvantum/main/src/Catppuccin-Mocha-Maroon/Catppuccin-Mocha-Maroon.svg";
        sha256 = "0crnd2bm92hagq6p0jzb23dviqqvhbmfm700c4g77xw08nwrqh2f";
      };
      "Kvantum/kvantum.kvconfig".source = (pkgs.formats.ini {}).generate "kvantum.kvconfig" {
        General.theme = "catppuccin";
        Applications.catppuccin = ''
          qt5ct, org.kde.dolphin, org.kde.kalendar, org.qbittorrent.qBittorrent, hyprland-share-picker, dolphin-emu, Nextcloud, nextcloud, cantata, org.kde.kid3-qt
        '';
      };
    };
  };
}
