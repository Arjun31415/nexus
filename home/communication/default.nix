{
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [
    inputs.arrpc.homeManagerModules.default
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

    whatsapp-for-linux
    teams-for-linux
    element-desktop-wayland
    webcord-vencord
    armcord
    clematis
    # (callPackage signal-desktop-beta {})
    signal-desktop-beta
    inputs.arrpc.packages.${pkgs.system}.arrpc
  ];
  # services.arrpc.enable = true;
}
