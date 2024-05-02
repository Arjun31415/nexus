{
  inputs,
  pkgs,
  ...
}: {
  imports = [./config.nix];
  programs.waybar = {
    enable = true;
    # package = inputs.waybar.packages.${pkgs.system}.default.override {
    #   hyprlandSupport = true;
    #   experimentalPatches = true;
    # };
    package = inputs.waybar.packages.${pkgs.system}.default;
    systemd.enable = false;
  };
}
