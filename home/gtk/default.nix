{pkgs, ...}: rec {
  home.packages = with pkgs; [
    home.pointerCursor.package
    gnome.gnome-tweaks
    #    gtk-engine-murrine
    gtk.theme.package
    gtk.iconTheme.package
  ];
  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.catppuccin-papirus-folders.override {
        flavor = "mocha";
        accent = "maroon";
      };
    };
    theme = {
      name = "Catppuccin-Mocha-Standard-Maroon-dark";
      package = pkgs.catppuccin-gtk.override {
        accents = ["maroon"];
        size = "standard";
        #        tweaks = ["rimless" "black"];
        variant = "mocha";
      };
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
  home.pointerCursor = {
    package = pkgs.catppuccin-cursors.mochaDark;
    name = "Catppuccin-Mocha-Maroon-Cursors";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };
  home.sessionVariables.GTK_THEME = "Catppuccin-Mocha-Standard-Maroon-dark";
}
