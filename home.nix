{
  config,
  pkgs,
  inputs,
  system,
  runCommand,
  makeWrapper,
  ...
}: let
  my-ncmpcpp = pkgs.ncmpcpp.override {
    visualizerSupport = true;
    clockSupport = true;
  };
  spicePkgs = inputs.spicetify-nix.packages.${pkgs.system}.default;
in {
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "prometheus";
  home.homeDirectory = "/home/prometheus";
  nixpkgs.config.allowUnfree = true;
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
    mcfly
    librewolf
    pastebinit
    inputs.anyrun.packages.${pkg.system}.anyrun-with-all-plugins
    # Not using it because spotify in nixpkgs is a snap, and adblock does not work on it
    # inputs.spotify-adblock.packages.${pkg.system}.spotify-adblock
    cliphist
    whatsapp-for-linux
    teams-for-linux
    element-desktop
    my-ncmpcpp
    mpc-cli
    gtk-engine-murrine
    xfce.thunar
    xfce.thunar-archive-plugin
    xfce.thunar-media-tags-plugin
    stow
    kooha
    cava
    cpupower-gui
    neofetch
    btop
    niv
    #    spotify
    wev
    ngrok
    imv
    webcord-vencord
    catppuccin-cursors
  ];
  services.mpd = {
    enable = true;
    musicDirectory = "/mnt/shared/PERSONAL/Music";
    dataDir = "${config.xdg.dataHome}/mpd";
    network = {
      listenAddress = "localhost";
      port = 6600;
    };
    extraConfig = ''
      user "prometheus"
       audio_output {
        type "pulse"
        name "pulse_audio"
       }

       audio_output {
       type "fifo"
       name "mpd_fifo"
       path "/tmp/mpd.fifo"
       format "44100:16:2"
       }
    '';
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
  services.dunst = {
    enable = true;
  };
  services.playerctld = {
    enable = true;
  };

  imports = [inputs.spicetify-nix.homeManagerModule];
  programs.spicetify = {
    enable = true;
    theme = spicePkgs.themes.catppuccin-mocha;
    colorScheme = "flamingo";

    enabledExtensions = with spicePkgs.extensions; [
      fullAppDisplay
      shuffle # shuffle+ (special characters are sanitized out of ext names)
      hidePodcasts
      adblock
      volumePercentage
    ];
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
