{
  callPackage,
  ignition,
  ...
}@args:
callPackage ./. (
  {
    majorVersion = "8";
    version = "8.3.0";
    srcHash = "sha256-qXce3btwZn/iZoLFCWMWJGv/AK0RgIYx6zbKoXdHjzY=";
    ignition-cmake = ignition.cmake4;
    ignition-utils = ignition.utils3;
  }
  // args
)
