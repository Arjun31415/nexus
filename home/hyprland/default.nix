{
  pkgs,
  inputs,
  impurity,
  ...
}: let
  inherit (inputs) hyprland hy3 hypridle hyprlock hyprland-plugins;
in {
  imports = [
    hyprland.homeManagerModules.default
    hypridle.homeManagerModules.default
    hyprlock.homeManagerModules.default
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    systemdIntegration = true;
    package = hyprland.packages.${pkgs.system}.hyprland;
    plugins = [
      # hy3.packages.${pkgs.system}.default
      # hyprland-plugins.packages.${pkgs.system}.hyprwinwrap
      hyprland-plugins.packages.${pkgs.system}.hyprexpo
    ];
    extraConfig = ''
      source = ${impurity.link ./hyprland.conf}
      bind = $mainMod, p, exec, cliphist list | anyrun --plugins ${inputs.anyrun.packages.${pkgs.system}.stdin}/lib/libstdin.so --show-results-immediately true --max-entries 100  | cliphist decode | wl-copy
    '';
  };
  services.hypridle = {
    enable = true;
    lockCmd = "swaylock";
    unlockCmd = "notify-send \"unlock!\""; # same as above, but unlock
    ignoreDbusInhibit = false;
    beforeSleepCmd = "notify-send \"Zzz\""; # command ran before sleep
    afterSleepCmd = "notify-send \"Awake!\""; # command ran after sleep
    listeners = [
      {
        timeout = 1200;
      }
    ];
  };
  programs.hyprlock = {
    enable = true;
    general.disable_loading_bar = false;
    backgrounds = [
      {
        monitor = "eDP-1";
        path = "/home/prometheus/Pictures/Wallpapers/Ayanokouji.png";
        # color = "rgba(25, 20, 20, 1.0)";
      }
    ];
    input-fields = [
      {
        monitor = "eDP-1";
        size = {
          width = 200;
          height = 50;
        };
        outline_thickness = 3;
        outer_color = "rgb(151515)";
        inner_color = "rgb(200, 200, 200)";
        font_color = "rgb(10, 10, 10)";
        fade_on_empty = true;
        placeholder_text = "<i>Input Password...</i>"; # Text rendered in the input box when it's empty.
        # hide_input = false;
        position = {
          x = 0;
          y = -20;
        };
        halign = "center";
        valign = "center";
      }
    ];
  };
}
