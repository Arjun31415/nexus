{
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    gh
    niv
    wakapi
  ];
  /* nixpkgs.overlays = [inputs.rust-overlay.overlays.default];
  home.packages = [pkgs.rust-bin.nightly.latest.default]; */
  programs.neovim = {
    package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.neovim;
    vimAlias = true;
    enable = true;
    viAlias = true;
    vimdiffAlias = true;
    withRuby = false;
    withNodeJs = true;
    withPython3 = true;
  };
  programs.go.enable = true;
  programs.vscode = {
    enable = true;
  };
}
