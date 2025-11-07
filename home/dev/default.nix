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
    neovide
    # google-cloud-sdk-gce
    tree-sitter
    fzf
    typst
    # jetbrainsPkgs.rustrover
  ];
  programs.yazi = {
    enableFishIntegration = true;
    enable = true;
    # package = inputs.yazi.packages.${pkgs.system}.default;
    keymap = {
      manager.prepend_keymap = [
        {
          on = ["<C-s>"];
          exec = "shell \"$SHELL\" --block --confirm";
          desc = "Open shell here";
        }
      ];
    };
  };
  # programs.zellij.enable = true;
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  programs.git = {
    lfs.enable = true;
    enable = true;
    settings.user.name = "Arjun31415";
    settings.user.email = "arjunp0710@gmail.com";
  };
  programs.delta.enable = true;

  programs.gitui.enable = true;
  programs.gh = {
    enable = true;
    extensions = [];
    gitCredentialHelper.enable = true;
    settings = {
      # Workaround for https://github.com/nix-community/home-manager/issues/4744
      version = 1;
      editor = "nvim";
    };
  };
  programs.gh-dash.enable = true;

  programs.neovim = {
    package = pkgs.neovim;
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
    package = pkgs.vscode.fhs;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      enkia.tokyo-night
      # wakatime.vscode-wakatime
      # rust-lang.rust-analyzer
      # svelte.svelte-vscode
      jock.svg
      # tabnine.tabnine-vscode
      tamasfe.even-better-toml
      # xadillax.viml
      ms-vscode.cpptools
      njpwerner.autodocstring
      twxs.cmake
      ms-vscode.cmake-tools
      vadimcn.vscode-lldb
      divyanshuagrawal.competitive-programming-helper
      yzhang.markdown-all-in-one
    ];
  };
  programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
      main = {
        font = "Fisa Code:style=Regular:size=10";
        dpi-aware = "yes";
      };
      colors = {
        background = "24283b";
        alpha = 0.85;
        ## Normal/regular colors (color palette 0-7)
        regular0 = "1d202f";
        regular1 = "f7768e";
        regular2 = "9ece6a";
        regular3 = "e0af68";
        regular4 = "7aa2f7";
        regular5 = "bb9af7";
        regular6 = "7dcfff";
        regular7 = "a9b1d6";

        # bright colors (color palette 8-15)

        bright0 = "414868";
        bright1 = "f7768e";
        bright2 = "9ece6a";
        bright3 = "e0af68";
        bright4 = "7aa2f7";
        bright5 = "bb9af7";
        bright6 = "7dcfff";
        bright7 = "c0caf5";
        ## The remaining 256-color palette
        "16" = "ff9e64";
        "17" = "db4b4b";
      };
      mouse = {
        hide-when-typing = "yes";
      };
    };
  };
}
