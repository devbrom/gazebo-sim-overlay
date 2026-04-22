{
  callPackage,
  ignition,
  ...
}@args:
callPackage ./. (
  {
    majorVersion = "8";
    version = "8.3.0";
    srcHash = "sha256-U02OIZ59IMxxbZeC8bjqmFKmfWTzDTc7F4YO5gsJdYg=";
    ignition-cmake = ignition.cmake4;
    ignition-utils = ignition.utils3;
    ignition-plugin = ignition.plugin3;
    ignition-common = ignition.common6;
    ignition-math = ignition.math8;
  }
  // args
)
