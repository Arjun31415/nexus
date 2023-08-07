{
  lib,
  stdenv,
  fetchFromGitHub,
  dbus,
  dconf,
  easyeffects,
  bash,
  ...
}:
stdenv.mkDerivation rec {
  pname = "EasyEffects-Presets";
  version = "master";

  src = fetchFromGitHub {
    owner = "JackHack96";
    repo = pname;
    rev = "834bc5007b976250190cd71937c8c22f182d2415";
    sha256 = "jMTQp2wdPOno/3FckKeOAV+ZMoalaWXIQkg+Aai3jaU=";
  };

  nativeBuildInputs = [easyeffects];

  runtimeDependencies = [bash dbus dconf easyeffects];

  buildInputs =
    runtimeDependencies;
  installPhase = "pwd";

  meta = with lib; {
    description = "Collection of presets for EasyEffects";
    inherit (src.meta) homepage;
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
