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
  ignition-cmake,
  protobuf,
  tinyxml-2,
  ignition-transport,
  ignition-rendering,
  ignition-msgs,
  ignition-tools,
  eigen,
  qtbase,
  qtquickcontrols2,
  qtdeclarative,
  qwt,
  patchelf,
  ...
}:
stdenv.mkDerivation rec {
  pname =
    if (lib.versionAtLeast version "8") then "gz-gui${majorVersion}" else "ignition-gui${majorVersion}";
  inherit version;

  src = fetchFromGitHub rec {
    name = "${rev}-source";
    owner = "gazebosim";
    repo = "gz-gui";
    rev = "${pname}_${version}";
    hash = srcHash;
  };
  # src = builtins.fetchGit "/home/bernd/git/gz-gui";

  nativeBuildInputs = [
    cmake
    pkg-config
    patchelf
  ];

  buildInputs = [ cmake ];

  postInstall = lib.optional (majorVersion == "6") ''
    patchelf --print-rpath "$out/lib/ign-gui-6/plugins/libGrid3D.so"
  '';
  propagatedBuildInputs = [
    qtbase
    qtquickcontrols2
    qtdeclarative
    ignition-tools
    pkg-config
    eigen
    qwt
    protobuf
    tinyxml-2
    ignition-math
    ignition-common
    ignition-plugin
    ignition-transport
    ignition-rendering
    ignition-msgs
    ignition-tools
    ignition-cmake
  ];

  patches = lib.optional (majorVersion == "8") [
    (fetchpatch {
      url = "https://github.com/gazebosim/gz-gui/pull/677.patch";
      hash = "sha256-9nX3/Yyxp5WSE8VvY+TWcfPFNlS8pdbtex0mujqiilw=";
    })
  ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_LIBDIR='lib'"
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
  ];

  dontWrapQtApps = true;

  meta = with lib; {
    homepage = "https://ignitionrobotics.org/libs/gui";
    description = ''
      Builds on top of Qt to provide widgets which are useful when developing
      robotics applications, such as a 3D view, plots, dashboard, etc, and can be used
      together in a convenient unified interface.'';
    license = licenses.asl20;
    maintainers = with maintainers; [ muellerbernd ];
    platforms = platforms.all;
  };
}
