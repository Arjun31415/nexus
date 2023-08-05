{
  inputs,
  pkgs,
  ...
}: {
  programs.waybar = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.waybar-hyprland;
    systemd.enable = true;
  };

}
