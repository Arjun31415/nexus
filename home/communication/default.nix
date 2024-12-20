{
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [
    # inputs.arrpc.homeManagerModules.default
    ./neomutt
  ];
  home.packages = with pkgs; [
    (inputs.wrapper-manager.lib.build
      {
        inherit pkgs;
        modules = [
          ./mailspring
        ];
      })
    # teams-for-linux
    element-desktop-wayland
    # (callPackage ../armcord {})
    clematis
    signal-desktop
    remmina
    # (discord-canary.override {withOpenASAR = true;})
    discord-canary
  ];
  # services.arrpc.enable = true;
}
