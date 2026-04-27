{
  lib,
  pkgs,
  stdenv,
  optimizationSupport ? true,
}:
stdenv.mkDerivation rec {
  pname = "guitarix";
  version = "a49015053ad6df6b0e4dca2580f987d047736f2e";
  src = pkgs.fetchFromGitHub {
    owner = "brummer10";
    repo = "guitarix";
    rev = version;
    hash = "sha256-Kkm+bJzK/BsyzHdDusHk8vV4pnaukTgBXj4FboZ61GI=";
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
    ladspa-header
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
