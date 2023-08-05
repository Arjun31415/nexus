{
  pkgs,
  inputs,
  ...
}: {
  nixpkgs.overlays = [inputs.rust-overlay.overlays.default];
  home.packages = with pkgs; [
    gh
    niv
    wakapi
    rust-bin.nightly.latest.default
    inputs.nix-nil-lsp.packages.${pkgs.system}.default
  ];
  programs = {
    direnv.enable = true;
    direnv.nix-direnv.enable = true;
  };

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
