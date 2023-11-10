{
  pkgs,
  inputs,
  impurity,
  stdenv,
  ...
}: let
  inherit (inputs) hyprland hy3;
in {
  imports = [hyprland.homeManagerModules.default];

  wayland.windowManager.hyprland = {
    enable = true;
    package = hyprland.packages.${pkgs.system}.hyprland-nvidia;
    plugins = [hy3.packages.${pkgs.system}.default];
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
