{
  callPackage,
  ignition,
}@args:
callPackage ./. (
  {
    majorVersion = "10";
    version = "10.1.0";
    srcHash = "sha256-ONo0zmKHSu1i6GAouDzFD5T2PUNXJ4IjhgPSoORRzao=";
    ignition-common = ignition.common6;
    ignition-msgs = ignition.msgs11;
    ignition-cmake = ignition.cmake4;
  }
  // args
)
