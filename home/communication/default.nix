{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./neomutt
  ];
  home.packages = with pkgs; [
    (inputs.wrapper-manager.lib
      {
        inherit pkgs;
        modules = [
          ./mailspring
        ];
      }).config.build.toplevel
    # teams-for-linux
    element
    clematis
    signal-desktop
    # (discord-canary.override {withOpenASAR = true;})
    # discord
    webcord-vencord
  ];
  services.arrpc.enable = true;
}
