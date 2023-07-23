{
  config,
  pkgs,
  inputs,
  system,
  ...
}: let
in {
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "azazel";
  home.homeDirectory = "/home/azazel";
  nixpkgs.config.allowUnfree = true;
  # nixpkgs.overlays = overlays;
  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.11";

  home.packages = with pkgs; [
    gh
    alejandra
    p7zip
    unzip
    starship
    librewolf
    wget
    ripgrep
    mcfly
    exa
    bat
    pastebinit
  ];

  programs.neovim = {
    package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.neovim;
    vimAlias = true;
    enable = true;
    viAlias = true;
    vimdiffAlias = true;
    withRuby = false;
    withNodeJs = false;
    withPython3 = false;
  };
  programs.vscode = {
   enable = true;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
