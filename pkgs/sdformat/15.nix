{
  callPackage,
  ignition,
  ...
}@args:
callPackage ./generic.nix (
  args
  // {
    version = "15.4.0";
    srcHash = "sha256-IrmCUgG/18DH7MYJle/KkL8Frq3cwwiuUYB0agjNC5A=";
    gz-cmake = ignition.cmake4;
    gz-math = ignition.math8;
    gz-utils = ignition.utils3;
  }
)
