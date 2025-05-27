{
  pkgs,
  lib,
  ...
}: let
  waybar_styles = builtins.readFile ./styles.css;
in {
  imports = [./scripts];
  programs.waybar.settings = {
    mainBar = {
      output = "eDP-1";
      layer = "top";
      position = "top";
      height = 30;
      "modules-left" = [
        "custom/launcher"
        "hyprland/workspaces"
        "custom/spotify"
      ];
      "modules-right" = [
        "backlight"
        #"custom/pacman"
        "battery"
        "network"
        # "pulseaudio"
        "wireplumber"
        "idle_inhibitor"
        "clock"
        "tray"
        "custom/power"
      ];
      "hyprland/workspaces" = {
        "disable-scroll" = true;
        "on-click" = "activate";
        "all-outputs" = true;
        "active-only" = "false";
        format = "{icon}";
        "format-icons" = {
          "1" = "1";
          "2" = "2";
          "3" = "3";
          "4" = "4";
          "5" = "5";
          "6" = "6";
          "7" = "7";
          "8" = "8";
          "9" = "9";
          "10" = "10";
        };
      };
      "hyprland/window" = {
        format = "{}";
        "separate-outputs" = true;
      };
      "idle_inhibitor" = {
        format = "<span font_weight='400' font_family=\"Material Design Icons\">{icon}</span>";
        "format-icons" = {
          activated = "";
          deactivated = "";
        };
      };
      tray = {
        "icon-size" = 14;
        spacing = 5;
      };
      clock = {
        "tooltip-format" = "{:%A %B %d %Y | %H:%M}";
        format = "<span font_weight='400' font_family=\"Material Design Icons\"></span> {:%a %d %b <span font_weight='400' font_family=\"Material Design Icons\"></span> %I:%M %p}"; #12 hour format
        "format-alt" = " {:%d/%m/%Y  %H:%M:%S}";
        interval = 1;
      };
      cpu = {
        format = "﬙ {usage: >3}%";
        "on-click" = "alacritty -e htop";
      };
      memory = {
        format = " {: >3}%";
        "on-click" = "alacritty -e htop";
      };
      temperature = {
        "critical-threshold" = 80;
        format = "{temperatureC}°C ";
      };
      backlight = {
        format = "<span font_family=\"Material Design Icons\">{icon} </span>{percent: >3}%";
        "format-icons" = [
          "󰃚"
          "󰃛"
          "󰃜"
          "󰃝"
          "󰃞"
          "󰃟"
          "󰃠"
        ];
        "on-scroll-down" = "brightnessctl -c backlight set 5%-";
        "on-scroll-up" = "brightnessctl -c backlight set +5%";
        tooltip = true;
        "tooltip-format" = "{percent}";
      };
      battery = {
        states = {
          full = 100;
          excellent = 90;
          good = 70;
          warning = 30;
          critical = 15;
        };
        interval = 10;
        format = "<span font_family=\"Font Awesome 6 Free Solid\">{icon} </span>{capacity: >3}%";
        "format-charging" = "<span size=\"larger\" font_family=\"Material Design Icons\">󰢞</span> {capacity}%";
        "format-icons" = ["" "" "" "" ""];
        tooltip = true;
        "tooltip-format" = "{} {time}";
      };
      network = {
        format = "⚠ Disabled";
        "format-wifi" = "<span font_family=\"Font Awesome\"></span> {essid}";
        "format-ethernet" = " : {ipaddr}/{cidr}";
        "format-disconnected" = "⚠ Disconnected";
        "on-click" = "kitty -e nmtui";
      };
      pulseaudio = {
        "scroll-step" = 5;
        format = "<span size=\"larger\" font_family=\"Material Design Icons\">{icon}</span>{volume: >3}%";
        "format-bluetooth" = "{icon}{volume: >3}%";
        "format-muted" = "<span size=\"larger\" font_family=\"Material Design Icons\">󰸈</span> muted";
        "format-icons" = {
          headphones = "";
          handsfree = "";
          headset = "";
          phone = "";
          portable = "";
          car = "";
          default = ["󰕿" "󰖀" "󰕾"];
        };
        "on-click" = "pwvucontrol";
      };
      wireplumber = {
        "scroll-step" = 5;
        format = "<span size=\"larger\" font_family=\"Material Design Icons\">{icon}</span>{volume: >3}%";
        "format-bluetooth" = "{icon}{volume: >3}%";
        "format-muted" = "<span size=\"larger\" font_family=\"Material Design Icons\">󰸈</span> muted";
        "format-icons" = {
          headphones = "";
          handsfree = "";
          headset = "";
          phone = "";
          portable = "";
          car = "";
          default = ["󰕿" "󰖀" "󰕾"];
        };
        "on-click" = "pwvucontrol";
      };
      "custom/power" = {
        format = "⏻";
        "on-click" = "nwg-bar";
        tooltip = false;
      };
      "custom/spotify" = {
        format = "<span font_family=\"Material Design Icons\">{icon}</span>{}";
        escape = true;
        "max-length" = 40;
        "on-click" = "playerctl play-pause";
        "on-click-right" = "expr 1 - $(cat /tmp/waybar_music_mode ) > /tmp/waybar_music_mode";
        "smooth-scrolling-threshold" = 5;
        "on-scroll-up" = "playerctl -p spotify next";
        "on-scroll-down" = "playerctl -p spotify previous";
        exec = "echo 0 > /tmp/waybar_music_mode && $HOME/.config/waybar/scripts/music_bar.sh";
        "exec-if" = "pgrep spotify || pgrep mpd";
      };
      "custom/launcher" = {
        format = "<span font_family=\"Material Symbols Rounded\"></span>";
        "on-click" = "exec ${lib.getExe pkgs.nwg-drawer} -c 7 -is 70 -spacing 23";
        tooltip = false;
      };
    };
  };
  programs.waybar.style = waybar_styles;
}
