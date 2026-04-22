{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  pkg-config,
  majorVersion ? "8",
  version ? "8.0.0",
  srcHash ? "sha256-JHRa84uED+dqu0EHrVFTh6o7eiVpgPbTYqpv8vZtJM4=",
  ignition-plugin,
  ignition-common,
  ignition-math,
  ogre-next,
  ogre1_9,
  ogre,
  eigen,
  freeimage,
  libGL,
  libGLU,
  xorg,
  boost,
  # Darwin-specific
  darwin ? null,
  OpenGL ? null,
  ...
}:
stdenv.mkDerivation rec {
  pname =
    if (lib.versionAtLeast version "8") then
      "gz-rendering${majorVersion}"
    else
      "ignition-rendering${majorVersion}";
  inherit version;

  src = fetchFromGitHub rec {
    name = "${rev}-source";
    owner = "gazebosim";
    repo = "gz-rendering";
    rev = "${pname}_${version}";
    hash = srcHash;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  propagatedBuildInputs = [
    ignition-math
    ignition-plugin
    ignition-common
    ogre-next
    ogre1_9
    ogre
    eigen
    freeimage
    boost
  ]
  ++ lib.optionals stdenv.isLinux [
    libGL
    libGLU
    xorg.libX11
  ]
  ++ lib.optionals stdenv.isDarwin [
    OpenGL
  ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_LIBDIR='lib'"
  ];

  buildInputs = [ cmake ];

  patches = lib.optional (majorVersion == "6") [ ./graphicsAPI.patch ];

  meta = with lib; {
    homepage = "https://ignitionrobotics.org/libs/rendering";
    description = ''
            C++ library designed to provide an abstraction for different rendering
      engines. It offers unified APIs for creating 3D graphics applications.'';
    license = licenses.asl20;
    maintainers = with maintainers; [ muellerbernd ];
    platforms = platforms.all;
  };
}
