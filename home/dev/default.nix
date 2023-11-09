{
  pkgs,
  inputs,
  ...
}: let
  jetbrainsPkgs = pkgs.callPackage ./jetbrains {};
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
  python-pkgs = ps:
    with ps; [
      pynvim
      pygobject3
    ];
in {
  imports = [./lsp];
  home.packages = with pkgs; [
    niv
    wakapi
    rust-bin.nightly.latest.default
    # tex
    pandoc
    (python311.withPackages python-pkgs)
    # jetbrainsPkgs.rustrover
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
    # package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default.override {
    #   libvterm-neovim = inputs.nixpkgs-staging.legacyPackages.${pkgs.system}.libvterm-neovim;
    # };
    package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;

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
    extensions = with pkgs.vscode-extensions; [
      enkia.tokyo-night
      wakatime.vscode-wakatime
      rust-lang.rust-analyzer
      svelte.svelte-vscode
      jock.svg
      tabnine.tabnine-vscode
      tamasfe.even-better-toml
      xadillax.viml
      ms-vscode.cpptools
      njpwerner.autodocstring
      twxs.cmake
      ms-vscode.cmake-tools
      vadimcn.vscode-lldb
      divyanshuagrawal.competitive-programming-helper
      yzhang.markdown-all-in-one
    ];
  };
}
