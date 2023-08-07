{
  pkgs,
  inputs,
  ...
}: {
  home.packages = [
    (inputs.wrapper-manager.lib.build
      {
        inherit pkgs;
        modules = [
          ./brave-x.nix
        ];
      })
  ];
  programs.chromium = {
    enable = true;
    extensions = [
      {id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";}
    ];
  };
}
