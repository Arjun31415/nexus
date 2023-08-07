{
  lib,
  stdenv,
  cmake,
  pkg-config,
  fetchFromGitHub,
  makeWrapper,
  # hard deps
  dbus,
  dconf,
  glib,
  pciutils,
  zlib,
  # soft deps
  enableChafa ? false,
  chafa,
  enableImageMagick ? false,
  imagemagick_light,
  enableOpenCLModule ? true,
  ocl-icd,
  opencl-headers,
  enableOpenGLModule ? true,
  libglvnd,
  enableVulkanModule ? true,
  vulkan-loader,
  enableWayland ? true,
  wayland,
  enableX11 ? true,
  libX11,
  libxcb,
  enableXFCE ? false,
  xfce,
}:
stdenv.mkDerivation rec {
  pname = "fastfetch";
  version = "1.12.2";

  src = fetchFromGitHub {
    owner = "fastfetch-cli";
    repo = pname;
    rev = version;
    sha256 = "l9fIm7+dBsOqGoFUYtpYESAjDy3496rDTUDQjbNU4U0=";
  };

  nativeBuildInputs = [cmake makeWrapper pkg-config];

  runtimeDependencies =
    [dbus dconf glib pciutils zlib]
    ++ lib.optional enableChafa chafa
    ++ lib.optional enableImageMagick imagemagick_light
    ++ lib.optional enableOpenCLModule ocl-icd
    ++ lib.optional enableOpenGLModule libglvnd
    ++ lib.optional enableVulkanModule vulkan-loader
    ++ lib.optional enableWayland wayland
    ++ lib.optional enableX11 libxcb
    ++ lib.optional enableXFCE xfce.xfconf;

  buildInputs =
    runtimeDependencies
    ++ lib.optional enableOpenCLModule opencl-headers
    ++ lib.optional enableX11 libX11;

  cmakeFlags = [
    "-DCMAKE_INSTALL_SYSCONFDIR=${placeholder "out"}/etc"
  ];

  ldLibraryPath = lib.makeLibraryPath runtimeDependencies;

  postInstall = ''
    wrapProgram $out/bin/fastfetch --prefix LD_LIBRARY_PATH : "${ldLibraryPath}"
    wrapProgram $out/bin/flashfetch --prefix LD_LIBRARY_PATH : "${ldLibraryPath}"
  '';

  meta = with lib; {
    description = "Like Neofetch, but much faster because written in C";
    inherit (src.meta) homepage;
    license = licenses.mit;
    platforms = platforms.linux;
  };
}