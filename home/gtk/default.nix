{
  inputs,
  pkgs,
  ...
}: let
  tokyonightGtkTheme = inputs.tokyonightNur.packages.${pkgs.system}.tokyonight-gtk-theme;
  tokyonightGtkIcons = inputs.tokyonightNur.packages.${pkgs.system}.tokyonight-gtk-icons;
  catppucin-cursors = inputs.catppuccin-cursors.packages.${pkgs.system}.default;
in rec {
  home.packages = with pkgs; [
    home.pointerCursor.package
    gnome-tweaks
    gtk.theme.package
    gtk.iconTheme.package
    nwg-drawer
    nwg-bar
    file-roller
    catppucin-cursors
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
      name = "catpuccin-mocha-maroon-cursors";
      package = pkgs.catppuccin-cursors.mochaMaroon;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      cursor-theme = "catpuccin-mocha-maroon-cursors";
      gtk-theme = "Tokyonight-Storm-BL";
      icon-theme = "Tokyonight-Dark";
      enable-hot-corners = false;
    };
  };
  home.pointerCursor = {
    package = pkgs.catppuccin-cursors.mochaMaroon;
    name = "catppuccin-mocha-maroon-cursors";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };
}
