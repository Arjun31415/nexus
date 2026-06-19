{
  inputs,
  pkgs,
  ...
}: {
  imports = [./config.nix];
  programs.waybar = {
    enable = true;
    # package = inputs.nixpkgs.packages.${pkgs.system}.waybar.default.override {
    #   hyprlandSupport = true;
    #   experimentalPatches = true;
    # };
    package = inputs.waybar.packages.${pkgs.system}.waybar.overrideAttrs (oldAttrs: {
      mesonFlags = (oldAttrs.mesonFlags or []) ++ ["-Dtests=disabled"];
    });
    systemd.enable = false;
  };
}
