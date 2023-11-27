{
  pkgs,
  inputs,
  impurity,
  stdenv,
  ...
}: let
  inherit (inputs) hyprland hy3 hyprland-plugins;
in {
  imports = [hyprland.homeManagerModules.default];

  wayland.windowManager.hyprland = {
    enable = true;
    package = hyprland.packages.${pkgs.system}.hyprland;
   # plugins = [hy3.packages.${pkgs.system}.default hyprland-plugins.packages.${pkgs.system}.hyprwinwrap];
    extraConfig = ''
      source = ${impurity.link ./hyprland.conf}
    '';
  };
  xdg.configFile."hypr/hy3-fullscreen.sh" = {
    source = ./hy3-fullscreen.sh;
    executable = true;
    onChange = "systemctl --user restart waybar";
  };
}
