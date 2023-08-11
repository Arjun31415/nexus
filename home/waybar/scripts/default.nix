{pkgs, ...}: let
in {
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
}
