{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # inputs.arrpc.homeManagerModules.default
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
    # (callPackage ../armcord {})
    clematis
    signal-desktop
    # (discord-canary.override {withOpenASAR = true;})
    discord-canary
  ];
  # services.arrpc.enable = true;
}
