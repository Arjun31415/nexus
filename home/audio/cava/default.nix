{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  alsa-lib,
  fftw,
  libpulseaudio,
  ncurses,
  pkgconfig,
  iniparser,
  pipewire,
  enablePipewire ? false,
  enablePulseaudio ? true,
  enableALSA ? true,
}:
stdenv.mkDerivation rec {
  pname = "cava";
  version = "0.9.0";

  buildInputs =
    [
      fftw
      ncurses
      iniparser
    ]
    ++ lib.optionals enableALSA [alsa-lib]
    ++ lib.optionals enablePulseaudio [libpulseaudio]
    ++ lib.optionals enablePipewire [pipewire pipewire.dev]
    # ++ lib.optionals enablePortaudio [portaudio];
    ;

  src = fetchFromGitHub {
    owner = "karlstav";
    repo = "cava";
    rev = version;
    # sha256 = "sha256-W/2B9iTcO2F2vHQzcbg/6pYBwe+rRNfADdOiw4NY9Jk=";
    hash = "sha256-mIgkvgVcbRdE29lSLojIzIsnwZgnQ+B2sgScDWrLyd8=";
  };
  # preinstall = ''
  #   ./autogen.sh
  #   ./configure;
  # '';
  # installPhase = ''
  #   runHook preInstall
  #   make
  # '';

  nativeBuildInputs = [pipewire.dev pkgconfig autoreconfHook];

  meta = with lib; {
    description = "Cross-platform Audio Visualizer";
    homepage = "https://github.com/karlstav/cava";
    license = licenses.mit;
    maintainers = with maintainers; [offline mirrexagon];
    platforms = platforms.linux;
    mainProgram = "cava";
  };
}
