{
  lib,
  pkgs,
  stdenv,
  optimizationSupport ? true,
}:
stdenv.mkDerivation rec {
  pname = "guitarix";
  version = "2c32355ea8ade7f50364310c250adcb17a012e8b";
  src = pkgs.fetchFromGitHub {
    owner = "brummer10";
    repo = "guitarix";
    rev = version;
    hash = "sha256-d88vvqccwNUday33dpphjF3x3l8IS2QMF0z+pFUubmY=";
    fetchSubmodules = true;
  };
  buildInputs = with pkgs; [
    avahi
    bluez
    boost
    curl
    eigen
    faust
    fftwFloat
    fftw
    gettext
    glib
    glib-networking.out
    glibmm
    gperf
    adwaita-icon-theme
    gsettings-desktop-schemas
    gtk3
    gtkmm3
    hicolor-icon-theme
    intltool
    ladspaH
    libjack2
    libsndfile
    lilv
    lrdf
    lv2
    sassc
    serd
    sord
    sratom
    zita-convolver
    zita-resampler
    waf
    liblo
  ];
  nativeBuildInputs = with pkgs; [
    gettext
    hicolor-icon-theme
    intltool
    pkg-config
    python3
    wafHook
    wrapGAppsHook3
  ];
  sourceRoot = "${src.name}/trunk";

  prePatch = ''
    patchShebangs --build tools/**
  '';
  wafConfigureFlags =
    [
      "--no-font-cache-update"
      "--shared-lib"
      "--no-desktop-update"
      "--enable-nls"
      "--install-roboto-font"
      "--includeconvolver"
      "--includeresampler"
      "--no-faust"
      "--lib-dev"
      "-j 4"
    ]
    ++ lib.optional optimizationSupport "--optimization";
  # preBuild = "./waf --help";

  env.NIX_CFLAGS_COMPILE = toString ["-fpermissive"];
}
