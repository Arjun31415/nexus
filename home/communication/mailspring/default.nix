{
  pkgs,
  lib,
  inputs,
  ...
}: let
  my-mailspring = pkgs.mailspring.overrideAttrs (old: {libPath = lib.makeLibraryPath [pkgs.libglvnd];});
in {
  wrappers.mailspring = {
    basePackage = my-mailspring;
    prependFlags = [
      "--password-store=gnome-libsecret"
    ];
  };
}
