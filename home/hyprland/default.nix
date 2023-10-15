{
  pkgs,
  inputs,
  impurity,
  stdenv,
  ...
}: let
  inherit (inputs) hyprland hy3;
  hy3-fullscreen = pkgs.writeShellScriptBin "hy3-fullscreen" builtins.readFile ./hy3-fullscreen.sh;
in {
  imports = [hyprland.homeManagerModules.default];

  wayland.windowManager.hyprland = {
    enable = true;
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
