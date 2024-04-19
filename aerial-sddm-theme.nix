{
  stdenv,
  fetchFromGitHub,
  gst_all_1,
  libsForQt5,
}:
stdenv.mkDerivation {
  name = "aerial-sddm-theme";
  dontBuild = true;
  # propagatedBuildInputs= with gst_all_1;
  #   [gst-plugins-good gst-libav]
  #   ++ (with libsForQt5; [
  #     phonon-backend-gstreamer
  #     qt5.qtmultimedia
  #     qt5.qtquickcontrols
  #     qt5.qtgraphicaleffects
  #   ]);
  installPhase = ''
    mkdir -p $out/share/sddm/themes
    cp -aR $src $out/share/sddm/themes/aerial-sddm-theme
  '';
  src = fetchFromGitHub {
    owner = "3ximus";
    repo = "aerial-sddm-theme";
    rev = "c8d2a8f50decd08cb30f2fe70205901014985c9e";
    sha256 = "sha256-hJiG9hGIza4z4dxR2+WFS94xiNZcioE+fcGZ83fgXjM=";
  };
}
