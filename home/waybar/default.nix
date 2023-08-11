{
  inputs,
  pkgs,
  ...
}: {
  imports = [./config.nix];
  programs.waybar = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.waybar-hyprland;
    systemd.enable = false;
  };
}
