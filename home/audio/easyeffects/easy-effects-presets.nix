{
  lib,
  stdenv,
  fetchFromGitHub,
  dbus,
  dconf,
  glib,
  pciutils,
  zlib,
  easyeffects,
  ...
}:
stdenv.mkDerivation rec {
  pname = "EasyEffects-Presets";
  version = "master";

  src = fetchFromGitHub {
    owner = "JackHack96";
    repo = pname;
    rev = version;
    sha256 = "l9fIm7+dBsOqGoFUYtpYESAjDy3496rDTUDQjbNU4U0=";
  };

  nativeBuildInputs = [easyeffects];

  runtimeDependencies = [dbus dconf glib pciutils zlib easyeffects];
  buildInputs =
    runtimeDependencies;
  installPhase = "./install.sh";

  /*
     postInstall = ''
    wrapProgram $out/bin/fastfetch --prefix LD_LIBRARY_PATH : "${ldLibraryPath}"
    wrapProgram $out/bin/flashfetch --prefix LD_LIBRARY_PATH : "${ldLibraryPath}"
  '';
  */

  meta = with lib; {
    description = "Collection of presets for EasyEffects";
    inherit (src.meta) homepage;
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
