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
    owner = "xaknick";
    repo = "tokyo-night-sddm-qt6";
    rev = "ffc26208bb6ddd033d1fe945d19b60e4e1b002b2";
    sha256 = "sha256-Tk0hXKFT/uE1ncIHSEwIC26Z/wC4wXb/7CnY3lBGzFM=";
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
    # $src is the unmodifed read only source originally cloned.
    cp -r . $out/share/sddm/themes/tokyo-night-sddm
    set +x
  '';
}
