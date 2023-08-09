{
  pkgs,
  inputs,
  ...
}: let
  tex = pkgs.texlive.combine {
    inherit
      (pkgs.texlive)
      scheme-medium
      dvisvgm
      dvipng # for preview and export as html
      wrapfig
      amsmath
      ulem
      hyperref
      ;
    #(setq org-latex-compiler "lualatex")
    #(setq org-preview-latex-default-process 'dvisvgm)
  };
in {
  nixpkgs.overlays = [inputs.rust-overlay.overlays.default];
  home.packages = with pkgs; [
    niv
    wakapi
    rust-bin.nightly.latest.default
    inputs.nix-nil-lsp.packages.${pkgs.system}.default
    # tex
    pandoc
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  programs.git = {
    enable = true;
    delta.enable = true;
    userName = "Arjun31415";
    userEmail = "arjunp0710@gmail.com";
  };
  programs.gh = {
    enable = true;
    extensions = [pkgs.gh-eco];
    gitCredentialHelper.enable = true;
    settings.editor = "nvim";
  };
  programs.gh-dash.enable = true;

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
