# Hate that I have to thank this doood : https://codeberg.org/jacekpoz/niksos/src/branch/master/modules/gui/qt.nix
{
  config,
  pkgs,
  lib,
  impurity,
  ...
}:
with lib; let
  cfg = config.myOptions.themes.qt;
  scheme = cfg.theme-package.name;
in {
  options.myOptions.themes.qt = {
    enable = mkEnableOption "enable qt theming";
    qbittorrent-theme = {
      enable = mkEnableOption "enable qbtorrent theme (.qbtheme). Will have to manually import it later in qbittorrent app";
      theme-file = mkOption {
        description = "the theme file contents";
      };
    };
    theme-package = {
      name = mkOption {
        description = "qt theme name";
        type = types.str;
      };
      package = mkOption {
        description = "qt theme package";
        type = types.package;
      };
    };
  };

  config = mkIf cfg.enable {
    qt = {
      enable = true;
      style = cfg.theme-package;
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
      "qBittorrent/themes/catppuccin.qbtheme".source = mkIf cfg.qbittorrent-theme.enable cfg.qbittorrent-theme.theme-file;
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
