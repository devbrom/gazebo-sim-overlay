{ callPackage, ... }@args:
callPackage ./. (
  {
    majorVersion = "4";
    version = "4.2.1";
    srcHash = "sha256-zhpZnvfnWsuyykIbNB4xgHxdO35otmaz0x/VXSdWPNY=";
  }
  // args
)
