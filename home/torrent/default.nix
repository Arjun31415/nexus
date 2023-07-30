{
  config,
  pkgs,
  ...
}: {
  programs.qbittorrent.enable = true;
  programs.Lidarr = {
    enable = true;
    package = pkgs.lidarr;
  };
  programs.sonarr.enable = true;
  programs.unpackerr.enable = true;
  programs.readarr.enable = true;
  #  programs.bazarr.enable = true;
}
