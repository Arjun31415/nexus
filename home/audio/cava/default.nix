{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  autoconf-archive,
  alsa-lib,
  fftw,
  libpulseaudio,
  pipewire,
  ncurses,
  pkgconfig,
  iniparser,
  SDL2,
  SDL2_gfx,
  libGL,
  withSDL2 ? false,
}:
stdenv.mkDerivation rec {
  pname = "cava";
  version = "0.9.1";
  LD_LIBRARY_PATH = "/run/opengl-driver/lib:/run/opengl-driver-32/lib";
  buildInputs =
    [
      fftw
      ncurses
      iniparser
      alsa-lib
      libpulseaudio
      pipewire
    ]
    ++ lib.optionals withSDL2 [
      SDL2
      SDL2_gfx
      SDL2.dev
      # needed for glsl
      libGL
    ];

  src = fetchFromGitHub {
    owner = "karlstav";
    repo = "cava";
    rev = version;
    hash = "sha256-W/2B9iTcO2F2vHQzcbg/6pYBwe+rRNfADdOiw4NY9Jk=";
  };

  nativeBuildInputs = [pkgconfig autoreconfHook autoconf-archive];

  meta = with lib; {
    description = "Cross-platform Audio Visualizer";
    homepage = "https://github.com/karlstav/cava";
    license = licenses.mit;
    maintainers = with maintainers; [offline mirrexagon];
    platforms = platforms.linux;
    mainProgram = "cava";
  };
}
