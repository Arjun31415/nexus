{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [qbittorrent deluge];

}
