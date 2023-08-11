with import <nixpkgs> {}; let
in
  pkgs.mkShell {
    buildInputs = [
      gtk3
      (python311.withPackages (ps:
        with ps; [
          pygobject3
        ]))
      gobject-introspection
      makeWrapper
      bashInteractive
    ];
    nativeBuildInputs = with pkgs; [
      gobject-introspection
      playerctl
    ];

  }
