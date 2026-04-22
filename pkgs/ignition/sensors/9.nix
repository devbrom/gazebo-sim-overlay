{
  callPackage,
  ignition,
  ...
}@args:
callPackage ./. (
  {
    majorVersion = "9";
    version = "9.2.0";
    srcHash = "sha256-Vxl3xdmh8ybRbjDxNGt8qgQOP9ctAcYAoVwWeytAglc=";
    ignition-plugin = ignition.plugin3;
    ignition-transport = ignition.transport14;
    ignition-rendering = ignition.rendering9;
    ignition-msgs = ignition.msgs11;
    ignition-cmake = ignition.cmake4;
    ignition-common = ignition.common6;
  }
  // args
)
