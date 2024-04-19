{
  stdenv,
  fetchFromGitHub,
}: let
  # nightbg = fetchurl {
  #   url = "https://videos.pexels.com/video-files/3571264/3571264-hd_1920_1080_30fps.mp4";
  #   hash = "sha256-+v+u3yiHO9f44Q31/ISmu7JsdxQDHwekJC3QyINAk84=";
  # };
in
  stdenv.mkDerivation {
    name = "tokyo-night-sddm-theme";
    dontBuild = true;
    # postUnpack = ''
    #   cp "${nightbg}" $src/backgrounds/nightbg.mp4
    # '';
    installPhase = ''
      mkdir -p $out/share/sddm/themes
      cp -aR $src $out/share/sddm/themes/genshin-sddm-theme
    '';
    src = fetchFromGitHub {
      owner = "siddrs";
      repo = "tokyo-night-sddm";
      rev = "320c8e74ade1e94f640708eee0b9a75a395697c6";
      sha256 = "";
    };
  }

