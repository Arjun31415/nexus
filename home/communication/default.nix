{
  pkgs,
  inputs,
  ...
}: {
  imports = [inputs.arrpc.homeManagerModules.default];
  home.packages = with pkgs; [
    whatsapp-for-linux
    teams-for-linux
    element-desktop-wayland
    webcord-vencord
    armcord
    clematis
    signal-desktop-beta
    inputs.arrpc.packages.${pkgs.system}.arrpc
    (mailspring.overrideAttrs
      (old: {
        libPath = lib.makeLibraryPath [pkgs.libglvnd];
      }))
  ];
  services.arrpc.enable = true;
}
