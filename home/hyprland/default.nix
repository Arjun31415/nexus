{
  pkgs,
  inputs,
  # impurity,
  ...
}: let
  inherit (inputs) hyprland hy3 hypridle hyprlock hyprland-plugins;

  hyprland_config = builtins.readFile ./hyprland.conf;
in {
  imports = [
    hyprland.homeManagerModules.default
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    package = hyprland.packages.${pkgs.system}.hyprland;
    plugins = [
      # hy3.packages.${pkgs.system}.default
      # hyprland-plugins.packages.${pkgs.system}.hyprwinwrap
      # hyprland-plugins.packages.${pkgs.system}.hyprexpo
    ];
    extraConfig = ''
      ${hyprland_config}
      bind = $mainMod, p, exec, cliphist list | anyrun --plugins ${inputs.anyrun.packages.${pkgs.system}.stdin}/lib/libstdin.so --show-results-immediately true --max-entries 100  | cliphist decode | wl-copy
    '';
  };
  # needed for sway
  # services.hypridle = {
  #   enable = true;
  #   lockCmd = "swaylock";
  #   unlockCmd = "notify-send \"unlock!\""; # same as above, but unlock
  #   ignoreDbusInhibit = false;
  #   beforeSleepCmd = "notify-send \"Zzz\""; # command ran before sleep
  #   afterSleepCmd = "notify-send \"Awake!\""; # command ran after sleep
  #   listeners = [
  #     {
  #       timeout = 1200;
  #     }
  #   ];
  # };
  programs.hyprlock = {
    package = hyprlock.packages.${pkgs.system}.hyprlock;
    enable = true;
    settings = {
      input-field = [
        {
          monitor = "eDP-1";
          size = "200, 50";
          outline_thickness = 3;
          outer_color = "rgb(151515)";
          inner_color = "rgb(200, 200, 200)";
          font_color = "rgb(10, 10, 10)";
          fade_on_empty = true;
          placeholder_text = "<i>Input Password...</i>"; # Text rendered in the input box when it's empty.
          # hide_input = false;
          position = "0, -20";
          halign = "center";
          valign = "center";
        }
      ];
      general.disable_loading_bar = false;
      background = [
        {
          monitor = "eDP-1";
          path = "/home/prometheus/Pictures/Wallpapers/Ayanokouji.png";
          # color = "rgba(25, 20, 20, 1.0)";
        }
        {
          monitor = "HDMI-A-1";
          path = "screenshot";
          blur_passes = 3;
          blur_size = 8;
        }
      ];
    };
  };
}
