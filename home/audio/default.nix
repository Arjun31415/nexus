{
  config,
  pkgs,
  inputs,
  ...
}: let
  my-ncmpcpp = pkgs.ncmpcpp.override {
    visualizerSupport = true;
    clockSupport = true;
  };

  spicetify = inputs.spicetify-nix;
  spicePkgs = spicetify.legacyPackages.${pkgs.system};
in {
  imports = [./easyeffects spicetify.homeManagerModules.default];

  home.packages = with pkgs; [
    my-ncmpcpp
    mpc-cli
    mpv
    amberol
    # (cava.override {withSDL2 = true;})
    (pkgs.callPackage ./cava.nix {})
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
  services.playerctld = {
    enable = true;
  };
  services.mpd-mpris = {
    enable = true;
    # package = inputs.mpd-mpris.packages.${pkgs.system}.default;
  };

  programs.spicetify = {
    enable = true;
    theme = spicePkgs.themes.catppuccin;
    colorScheme = "moccha";
    enabledExtensions = with spicePkgs.extensions; [
      fullAppDisplay
      shuffle
      hidePodcasts
      adblock
      volumePercentage
    ];
    enabledCustomApps = with spicePkgs.apps; [reddit lyricsPlus];
  };
}
