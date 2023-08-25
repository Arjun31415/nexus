{
  pkgs,
  inputs,
  impurity,
  ...
}: let
  inherit (inputs) hyprland hy3;
in {
  imports = [hyprland.homeManagerModules.default];

  wayland.windowManager.hyprland = {
    enable = true;
    plugins = [hy3.packages.${pkgs.system}.default];
    extraConfig = ''
      source = ${impurity.link ./hyprland.conf}
    '';
  };
}
