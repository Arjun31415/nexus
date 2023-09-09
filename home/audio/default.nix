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
  spicePkgs = spicetify.packages.${pkgs.system}.default;
in {
  imports = [./easyeffects spicetify.homeManagerModule];

  home.packages = with pkgs; [
    my-ncmpcpp
    mpc-cli
    mpv
    amberol
    (callPackage ./cava {withSDL2 = true;})
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
    package = inputs.mpd-mpris.packages.${pkgs.system}.default;
  };

  programs.spicetify = {
    enable = true;
    theme = spicePkgs.themes.catppuccin-mocha;
    colorScheme = "flamingo";
    enabledExtensions = with spicePkgs.extensions; [
      fullAppDisplay
      shuffle
      hidePodcasts
      adblock
      volumePercentage
    ];
  };
}
