# Brave on XWayland, because of Nvidia
{pkgs, ...}: {
  wrappers.bravex = {
    basePackage = pkgs.brave;
    flags = [
      "--enable-features=WebUIDarkMode"
      "--force-dark-mode"
    ];
    extraWrapperFlags = "--unset WAYLAND_DISPLAY";
  };
}
