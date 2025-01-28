{
  inputs,
  pkgs,
  lib,
  ...
}: let
  tokyonightGtkTheme = inputs.tokyonightNur.packages.${pkgs.system}.tokyonight-gtk-theme;
  tokyonightGtkIcons = inputs.tokyonightNur.packages.${pkgs.system}.tokyonight-gtk-icons;
in rec {
  home.packages = with pkgs; [
    gnome-tweaks
    gtk.theme.package
    gtk.iconTheme.package
    nwg-drawer
    nwg-bar
    file-roller
  ];
  catppuccin = {
    flavor = "mocha";
    accent = "maroon";
  };
  # gtk.catppuccin.enable = true;
  # gtk.catppuccin.accent = "maroon";
  # gtk.catppuccin.flavor = "mocha";
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
    # cursorTheme = {
    #   name = "catppuccin-mocha-maroon-cursors";
    #   package = pkgs.catppuccin-cursors.mochaMaroon;
    # };
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
      # this will be set by catppuccin home manager module
      # cursor-theme = "catpuccin-mocha-maroon-cursors";
      gtk-theme = "Tokyonight-Storm-BL";
      icon-theme = "Tokyonight-Dark";
      enable-hot-corners = false;
    };
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };
  catppuccin.cursors = {
    enable = true;
    accent = "maroon";
    flavor = "mocha";
  };
  # home.pointerCursor = {
  #   package = pkgs.catppuccin-cursors.mochaMaroon;
  #   name = "catppuccin-mocha-maroon-cursors";
  #   size = 24;
  #   gtk.enable = true;
  #   x11.enable = true;
  # };
}
