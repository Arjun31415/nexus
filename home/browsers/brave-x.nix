# Brave on XWayland, because of Nvidia
{pkgs, ...}: {
  wrappers.bravex = {
    basePackage = pkgs.brave;
    prependFlags = [
      "--enable-features=WebUIDarkMode"
    ];
    # extraWrapperFlags = "--unset WAYLAND_DISPLAY --unset NIXOS_OZONE_WL";
  };
}
