{
  qtbase,
  qtsvg,
  wrapQtAppsHook,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation
{
  name = "tokyo-night-sddm";
  dontBuild = true;
  src = fetchFromGitHub {
    owner = "Arjun31415";
    repo = "tokyo-night-sddm-qt6";
    rev = "9862a74ed77c840b1d3e5f7f86a814afdf367884";
    sha256 = "sha256-r6k7QUpCG2GAp28nUphymVrLm08Re9eqmc/ErynFCDI=";
  };
  patchPhase = ''
    sed -i 's|Background="Backgrounds/win11.png"|Background="Backgrounds/tokyocity.png"|g' theme.conf
  '';
  nativeBuildInputs = [
    wrapQtAppsHook
  ];
  buildInputs = [
    qtbase
  ];

  propagatedUserEnvPkgs = [
    qtbase
    qtsvg
  ];

  installPhase = ''
    set -x
    mkdir -p $out/share/sddm/themes
    # $src is the unmodified read only source originally cloned.
    cp -r . $out/share/sddm/themes/tokyo-night-sddm
    set +x
  '';
}
