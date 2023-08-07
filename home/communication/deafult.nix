{
  pkgs,
  inputs,
  ...
}: {
  home.package = with pkgs; [
    whatsapp-for-linux
    teams-for-linux
    element-desktop-wayland
    webcord-vencord
  ];
}
