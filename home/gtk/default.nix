{
  inputs,
  pkgs,
  lib,
  ...
}: let
  # tokyonightGtkTheme = inputs.tokyonightNur.packages.${pkgs.system}.tokyonight-gtk-theme;
  tokyonightGtkIcons = inputs.tokyonightNur.packages.${pkgs.system}.tokyonight-gtk-icons;
  tokyonightPkg = pkgs.tokyonight-gtk-theme.overrideAttrs {iconVariants = ["Dark"];};
  flavor = "mocha";
  accent = "maroon";
in rec {
  home.packages = with pkgs; [
    gnome-tweaks
    # gtk.theme.package
    # gtk.iconTheme.package
    nwg-drawer
    nwg-bar
    file-roller
    # tokyonightPkg
  ];
  catppuccin = {
    inherit flavor accent;
    cursors = {
      inherit flavor accent;
      enable = true;
    };
  };
  gtk = {
    enable = true;
    iconTheme = {
      name = "Tokyonight-Light";
      package = tokyonightGtkIcons;
    };
    theme = {
      name = "Tokyonight-Dark";
      package = tokyonightPkg;
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
      # this will be set by catppuccin home manager module
      # cursor-theme = "catpuccin-mocha-maroon-cursors";
      # gtk-theme = "Tokyonight-Dark";
      # icon-theme = "Tokyonight-Dark";
      enable-hot-corners = false;
    };
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };
  # home.pointerCursor = {
  #   package = pkgs.catppuccin-cursors.mochaMaroon;
  #   name = "catppuccin-mocha-maroon-cursors";
  #   size = 24;
  #   gtk.enable = true;
  #   x11.enable = true;
  # };
}
