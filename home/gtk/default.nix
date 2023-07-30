{pkgs, ...}: {
  home.packages = with pkgs; [
    gnome.gnome-tweaks
    gtk-engine-murrine
  ];
  gtk = {
    enable = true;
    cursorTheme = {
      name = "Catpuccin-Mocha-Maroon";
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
}
