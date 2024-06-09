{
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs;
    [
      stylua
      lua-language-server
      inputs.nix-nil-lsp.packages.${pkgs.system}.default
      clang-tools_17
      shellcheck
      pyright
      prettierd
      cmake-language-server
      rust-analyzer
      # inputs.nix-nixd-lsp.packages.${pkgs.system}.default
      # Linters
      selene # lua
    ]
    ++ (with pkgs.nodePackages_latest; [
      bash-language-server
      typescript-language-server
      vim-language-server
      vscode-css-languageserver-bin
      vscode-json-languageserver-bin
    ]);
}
