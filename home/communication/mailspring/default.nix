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
    flags = [
      "--password-store=gnome-libsecret"
    ];
  };
}
