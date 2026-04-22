{
  pkgs ? import <nixpkgs> { },
  ...
}:
let
  inherit (pkgs) lib stdenv;
  nixgl = pkgs.nixgl.nixGLIntel;
in
{
  default = pkgs.mkShell {
    name = "Gz sim development";
    buildInputs = [ pkgs.gz-ionic ] ++ lib.optionals stdenv.isLinux [ nixgl ];
    shellHook = ''
      unset QT_QPA_PLATFORM
      unset QT_PLUGIN_PATH
    '';
  };
  ionic = pkgs.mkShell {
    name = "Gz sim development";
    buildInputs = [ pkgs.gz-ionic ] ++ lib.optionals stdenv.isLinux [ nixgl ];
    shellHook = ''
      unset QT_QPA_PLATFORM
      unset QT_PLUGIN_PATH
    '';
  };
  harmonic = pkgs.mkShell {
    name = "Gz sim development";
    buildInputs = [ pkgs.gz-harmonic ] ++ lib.optionals stdenv.isLinux [ nixgl ];
    shellHook = ''
      unset QT_QPA_PLATFORM
      unset QT_PLUGIN_PATH
    '';
  };
  fortress = pkgs.mkShell {
    name = "Gz sim development";
    buildInputs = [ pkgs.ignition-fortress ] ++ lib.optionals stdenv.isLinux [ nixgl ];
    shellHook = ''
      unset QT_QPA_PLATFORM
      unset QT_PLUGIN_PATH
    '';
  };
}
