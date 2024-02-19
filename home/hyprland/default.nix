{
  pkgs,
  inputs,
  impurity,
  ...
}: let
  inherit (inputs) hyprland hy3 hypridle;
in {
  imports = [
    hyprland.homeManagerModules.default
    hypridle.homeManagerModules.default
  ];

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
}
