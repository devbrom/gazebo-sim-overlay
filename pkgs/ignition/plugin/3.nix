{
  callPackage,
  ignition,
  ...
}@args:
callPackage ./. (
  {
    majorVersion = "3";
    version = "3.1.0";
    srcHash = "sha256-3La9TqxljV1Lko6ju+b8CCspDbhXGPLOGMivqYElTXM=";
    ignition-cmake = ignition.cmake4;
    ignition-utils = ignition.utils3;
  }
  // args
)
