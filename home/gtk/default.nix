{
  inputs,
  pkgs,
  lib,
  ...
}: let
  tokyonightSrc = pkgs.fetchFromGitHub {
    owner = "Fausto-Korpsvart";
    repo = "Tokyo-Night-GTK-Theme";
    rev = "6c340e058e84c1975a038a8e5d1e384477225dc0";
    hash = "sha256-7H2n9wTaW8Db1RejWK071ITV1j5KIuzfql0Tx9WT6zM=";
  };
  tokyonightGtkIcons = inputs.tokyonightNur.packages.${pkgs.system}.tokyonight-gtk-icons.overrideAttrs (old: {
    version = "0-unstable-2025-10-23";
    src = tokyonightSrc;
  });
  tokyonightPkg = inputs.tokyonightNur.packages.${pkgs.system}.tokyonight-gtk-theme.overrideAttrs (old: {
    version = "0-unstable-2025-10-23";
    src = tokyonightSrc;
  });
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
    gtk4.theme = null;
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
