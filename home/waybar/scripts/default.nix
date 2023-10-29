{pkgs, ...}: {
  home.packages = [
    pkgs.gobject-introspection
  ];
  xdg.configFile."waybar/scripts/music_bar.sh" = {
    source = ./music_bar.sh;
    executable = true;
    onChange = "systemctl --user restart waybar";
  };
  xdg.configFile."waybar/scripts/mediaplayer.py" = {
    source = ./mediaplayer.py;
    executable = true;
  };
  xdg.configFile."waybar/scripts/default.nix" = {
    source = ./waybar-default.nix;
  };
  xdg.configFile."waybar/scripts/waybar-cava.sh" = {
    source = ./waybar-cava.sh;
    executable = true;
  };
}
