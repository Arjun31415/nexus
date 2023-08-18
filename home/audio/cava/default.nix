{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  alsa-lib,
  fftw,
  libpulseaudio,
  ncurses,
  iniparser,
  portaudio,
  pipewire,
  enablePipewire ? false,
  enablePulseaudio ? true,
  enablePortaudio ? false,
  enableSndio ? false,
  enableALSA ? true,
}:
stdenv.mkDerivation rec {
  pname = "cava";
  version = "0.9.1";

  buildInputs =
    [
      alsa-lib
      fftw
      libpulseaudio
      ncurses
      iniparser
    ]
    ++ lib.optionals enablePipewire [pipewire]
    ++ lib.optionals enablePortaudio [portaudio];

  src = fetchFromGitHub {
    owner = "karlstav";
    repo = "cava";
    rev = version;
    sha256 = "sha256-mIgkvgVcbRdE29lSLojIzIsnwZgnQ+B2sgScDWrLyd8=";
  };

  nativeBuildInputs = [autoreconfHook];

  meta = with lib; {
    description = "Cross-platform Audio Visualizer";
    homepage = "https://github.com/karlstav/cava";
    license = licenses.mit;
    maintainers = with maintainers; [offline mirrexagon];
    platforms = platforms.linux;
    mainProgram = "cava";
  };
}
