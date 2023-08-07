{
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
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
