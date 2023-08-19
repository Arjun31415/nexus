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
  SDL2,
  SDL2_gfx,
  enablePulseaudio ? true,
  enableALSA ? true,
  enableSDL2 ? false,
}:
stdenv.mkDerivation rec {
  pname = "cava";
  version = "0.8.3";

  buildInputs =
    [
      fftw
      ncurses
      iniparser
    ]
    ++ lib.optionals enableALSA [alsa-lib]
    ++ lib.optionals enablePulseaudio [libpulseaudio]
    ++ lib.optionals enableSDL2 [SDL2]
    ;

  src = fetchFromGitHub {
    owner = "karlstav";
    repo = "cava";
    rev = version;
    # hash = "sha256-mIgkvgVcbRdE29lSLojIzIsnwZgnQ+B2sgScDWrLyd8=";
    sha256 = "sha256-6xiWhWynIbUWFIieiYIg24PgwnKuNSIEpkY+P6gyFGw=";
  };

  nativeBuildInputs = [pkgconfig autoreconfHook];

  meta = with lib; {
    description = "Cross-platform Audio Visualizer";
    homepage = "https://github.com/karlstav/cava";
    license = licenses.mit;
    maintainers = with maintainers; [offline mirrexagon];
    platforms = platforms.linux;
    mainProgram = "cava";
  };
}
