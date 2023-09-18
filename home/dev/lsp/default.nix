{
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    stylua
    lua-language-server
    inputs.nix-nil-lsp.packages.${pkgs.system}.default
    clang-tools
    shellcheck
    nodePackages_latest.bash-language-server
    nodePackages_latest.pyright
    nodePackages_latest.typescript-language-server
    nodePackages_latest.vim-language-server
    nodePackages.vscode-css-languageserver-bin
    nodePackages_latest.vscode-json-languageserver-bin
    prettierd
    cmake-language-server
    rust-analyzer

    # Linters
    selene # lua
  ];
}
