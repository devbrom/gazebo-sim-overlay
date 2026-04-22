{
  callPackage,
  ignition,
  ...
}@args:
callPackage ./. (
  {
    majorVersion = "14";
    version = "14.2.0";
    srcHash = "sha256-jvEVa0BK7hnYWybNXh30KpNu00+OTtR9bdHCiN8Bpeg=";
  }
  // args
)
