{
  pkgs,
  inputs,
  impurity,
  ...
}: let
  inherit (inputs) hyprland hy3 hyprland-plugins;
in {
  imports = [hyprland.homeManagerModules.default];

  wayland.windowManager.hyprland = {
    enable = true;
    systemdIntegration = true;
    package = hyprland.packages.${pkgs.system}.hyprland;
    plugins = [
      hy3.packages.${pkgs.system}.default
      # hyprland-plugins.packages.${pkgs.system}.hyprwinwrap
    ];
    extraConfig = ''
      source = ${impurity.link ./hyprland.conf}
      bind = $mainMod, p, exec, cliphist list | anyrun --plugins ${inputs.anyrun.packages.${pkgs.system}.stdin}/lib/libstdin.so --show-results-immediately true --max-entries 100  | cliphist decode | wl-copy
    '';
  };
  xdg.configFile."hypr/hy3-fullscreen.sh" = {
    source = ./hy3-fullscreen.sh;
    executable = true;
    onChange = "systemctl --user restart waybar";
  };
}
