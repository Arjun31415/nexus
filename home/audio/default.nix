{
  config,
  pkgs,
  inputs,
  system,
  home,
  ...
}: let
  my-ncmpcpp = pkgs.ncmpcpp.override {
    visualizerSupport = true;
    clockSupport = true;
  };
  spicePkgs = inputs.spicetify-nix.packages.${pkgs.system}.default;
in {
  home.packages = with pkgs; [
    my-ncmpcpp
    mpc-cli
    cava
    mpv
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
}
