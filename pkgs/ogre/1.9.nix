{
  fetchFromGitHub,
  stdenv,
  lib,
  cmake,
  libGLU,
  libGL,
  freetype,
  freeimage,
  zziplib,
  xorgproto,
  libXrandr,
  libXaw,
  freeglut,
  libXt,
  libpng,
  boost,
  ois,
  libX11,
  libXmu,
  libSM,
  pkg-config,
  libXxf86vm,
  libICE,
  libXrender,
  withNvidiaCg ? false,
  nvidia_cg_toolkit,
  withSamples ? false,
  # Darwin-specific
  darwin ? null,
  ApplicationServices ? null,
  Cocoa ? null,
  Foundation ? null,
  IOKit ? null,
  OpenGL ? null,
}:
stdenv.mkDerivation rec {
  pname = "ogre";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "OGRECave";
    repo = "ogre";
    rev = "v${version}";
    sha256 = "11lfgzqaps3728dswrq3cbwk7aicigyz08q4hfyy6ikc6m35r4wg";
  };

  # Patches for Darwin compatibility
  patches = lib.optionals stdenv.isDarwin [
    ./fix-binary-function.patch      # Fix for C++17 compatibility
    ./fix-auto-ptr.patch             # Fix for C++17 compatibility
    ./fix-sse-darwin.patch           # Fix SSE detection and usage on ARM macOS
    ./fix-utf-string-libcxx.patch    # libc++ compatibility (macOS/BSD)
    ./fix-atomic-darwin.patch        # Remove -latomic on macOS (not needed)
    ./fix-ditto-darwin.patch         # Replace ditto with cp
    ./fix-render-system-darwin.patch # Exclude Carbon/AGL files on ARM64 as they are not available
  ];

  cmakeFlags = [
    "-DOGRE_BUILD_SAMPLES=${toString withSamples}"
  ]
  ++ map (x: "-DOGRE_BUILD_PLUGIN_${x}=on") (
    [
      "BSP"
      "OCTREE"
      "PCZ"
      "PFX"
    ]
    ++ lib.optional withNvidiaCg "CG"
  )
  ++ map (x: "-DOGRE_BUILD_RENDERSYSTEM_${x}=on") [ "GL" ]
  ++ lib.optionals stdenv.isDarwin [
    # Work around Boost 1.87+ CMake detection issues on macOS
    "-DBoost_NO_BOOST_CMAKE=ON"
    "-DBOOST_ROOT=${boost.dev}"
    "-DBoost_NO_SYSTEM_PATHS=ON"
  ]
  ++ lib.optionals (stdenv.isDarwin && stdenv.isAarch64) [
    # Disable SSE/x86 intrinsics on ARM macOS
    "-DOGRE_CONFIG_ENABLE_SSE=OFF"
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    freetype
    freeimage
    zziplib
    libpng
    boost
    ois
  ]
  ++ lib.optionals stdenv.isLinux [
    libGLU
    libGL
    xorgproto
    libXrandr
    libXaw
    freeglut
    libXt
    libX11
    libXmu
    libSM
    libXxf86vm
    libICE
    libXrender
  ]
  ++ lib.optionals stdenv.isDarwin [
    ApplicationServices
    Cocoa
    Foundation
    IOKit
    OpenGL
  ]
  ++ lib.optionals withNvidiaCg [
    nvidia_cg_toolkit
  ];

  meta = with lib; {
    description = "3D Object-Oriented Graphics Rendering Engine";
    homepage = "https://www.ogre3d.org/";
    maintainers = with maintainers; [ lopsided98 ];
    platforms = platforms.unix;
    license = licenses.mit;
  };
}

