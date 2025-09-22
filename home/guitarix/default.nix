{pkgs, ...}: {
  home.packages = [
    (pkgs.callPackage ./pkg.nix {})
  ];
}
