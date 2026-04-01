{
  pkgs ? import <nixpkgs> { },
  ...
}:
{
  # classic = pkgs.mkShell {
  #   name = "Gazebo classic development";
  #   buildInputs = [
  #     pkgs.gazebo
  #   ];
  #   shellHook = ''
  #     unset QT_QPA_PLATFORM
  #     unset QT_PLUGIN_PATH
  #   '';
  # };
  default = pkgs.mkShell {
    name = "Gz sim development";
    buildInputs = [ pkgs.gz-ionic ];
    shellHook = ''
      unset QT_QPA_PLATFORM
      unset QT_PLUGIN_PATH
    '';
  };
  harmonic = pkgs.mkShell {
    name = "Gz sim development";
    buildInputs = [ pkgs.gz-harmonic ];
    shellHook = ''
      unset QT_QPA_PLATFORM
      unset QT_PLUGIN_PATH
    '';
  };
  fortress = pkgs.mkShell {
    name = "Gz sim development";
    buildInputs = [ pkgs.ignition-fortress ];
    shellHook = ''
      unset QT_QPA_PLATFORM
      unset QT_PLUGIN_PATH
    '';
  };
}
