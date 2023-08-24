{
  inputs,
  pkgs,
  ...
}: {
  imports = [./config.nix];
  programs.waybar = {
    enable = true;
    package = pkgs.waybar-experimental.override {hyprlandSupport = true;};
    systemd.enable = false;
  };
}
