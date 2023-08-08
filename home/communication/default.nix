{
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    whatsapp-for-linux
    teams-for-linux
    element-desktop-wayland
    webcord-vencord
    (mailspring.overrideAttrs
      (old: {
        libPath = lib.makeLibraryPath [pkgs.libglvnd];
      }))
  ];
}
