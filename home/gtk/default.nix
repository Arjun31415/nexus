{
  inputs,
  pkgs,
  ...
}: let
  tokyonightGtkTheme = inputs.tokyonightNur.packages.${pkgs.system}.tokyonight-gtk-theme;
  tokyonightGtkIcons = inputs.tokyonightNur.packages.${pkgs.system}.tokyonight-gtk-icons;
in rec {
  home.packages = with pkgs; [
    home.pointerCursor.package
    gnome.gnome-tweaks
    gtk.theme.package
    gtk.iconTheme.package
    nwg-drawer
    nwg-bar
    gnome.file-roller
  ];
  gtk = {
    enable = true;
    iconTheme = {
      name = "Tokyonight-Dark";
      package = tokyonightGtkIcons;
    };
    theme = {
      name = "Tokyonight-Storm-BL";
      package = tokyonightGtkTheme;
    };
    cursorTheme = {
      name = "Catpuccin-Mocha-Maroon-Cursors";
      package = pkgs.catppuccin-cursors.mochaMaroon;
    };
    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };

    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
  };
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      cursor-theme = "Catpuccin-Mocha-Maroon-Cursors";
      gtk-theme = "Tokyonight-Storm-BL";
      icon-theme = "Tokyonight-Dark";
      enable-hot-corners = false;
    };
  };
  home.pointerCursor = {
    package = pkgs.catppuccin-cursors.mochaDark;
    name = "Catppuccin-Mocha-Maroon-Cursors";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };
}
