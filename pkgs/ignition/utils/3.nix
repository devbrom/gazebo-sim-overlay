{
  callPackage,
  ignition,
  pkgs,
  ...
}@args:
callPackage ./. (
  {
    majorVersion = "3";
    version = "3.1.1";
    srcHash = "sha256-fYzysdB608jfMb/EbqiGD4hXmPxcaVTUrt9Wx0dBlto=";
    ignition-cmake = ignition.cmake4;
  }
  // args
)
