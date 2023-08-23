{
  inputs,
  pkgs,
  ...
}: {
  imports = [./config.nix];
  programs.waybar = {
    enable = true;
    package = pkgs.waybar-hyprland;
    systemd.enable = false;
  };
}
