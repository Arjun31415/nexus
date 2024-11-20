{
  lib,
  pkgs,
  stdenv,
}:
stdenv.mkDerivation rec {
  pname = "cava";
  version = "0.10.3";
  src = pkgs.fetchFromGitHub {
    owner = "karlstav";
    repo = "cava";
    rev = version;
    hash = "sha256-qpQ1WFWqq4FzeN0Yy8ke3mOYtGXmK998yZAy9OTBGq4=";
  };
  buildInputs = with pkgs; [
    fftw
    iniparser
    libpulseaudio
    libtool
    ncurses
    alsa-lib
    libGL
    SDL2
    pipewire
  ];
  nativeBuildInputs = with pkgs; [
    autoreconfHook
    autoconf
    pkgconf
  ];
  doInstallCheck = true;
  versionCheckProgramArg = "-v";
  preAutoreconf = ''
    echo ${version} > version
  '';
}
