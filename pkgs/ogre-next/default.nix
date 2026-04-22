{
  fetchFromGitHub,
  fetchpatch,
  stdenv,
  lib,
  cmake,
  freetype,
  freeimage,
  zziplib,
  ninja,
  tinyxml,
  rapidjson,
  cppunit,
  vulkan-headers,
  shaderc,
  SDL2,
  doxygen,
  graphviz,
  zlib,
  # Optional dependencies
  withOpenVR ? false,
  openvr ? null,
  # Linux-specific
  libGLU ? null,
  libXaw ? null,
  libXrandr ? null,
  mesa ? null,
  # Darwin-specific
  darwin ? null,
  ApplicationServices ? null,
  Cocoa ? null,
  Foundation ? null,
  IOKit ? null,
  Metal ? null,
  OpenGL ? null,
}:
stdenv.mkDerivation rec {
  pname = "ogre-next";
  version = "2.3.3";

  src = fetchFromGitHub {
    owner = "OGRECave";
    repo = "ogre-next";
    rev = "v${version}";
    sha256 = "sha256-elSj35LwsLzj1ssDPsk9NW/KSXfiOGYmw9hQSAWdpFM=";
  };

  # Patches for Darwin compatibility (only for 2.3.1, may need adjustment for 2.3.3)
  patches = lib.optionals stdenv.isDarwin [
    (fetchpatch {
      url = "https://github.com/scpeters/ogre-next/commit/b7439ae047489aa104a6775a99a9e93294c3d5b5.patch?full_index=1";
      hash = "sha256-Rvh0eQ9tpm98atgdcDH8Nu315ZxOJ6wpH0jaIfpx1EI=";
    })
    ./darwin-replace-ditto-with-cp.patch
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DOGRE_CONFIG_ENABLE_JSON=ON"
    "-DOGRE_CONFIG_THREADS=1"
    "-DOGRE_CONFIG_THREAD_PROVIDER=std"
    "-DOGRE_BUILD_COMPONENT_PLANAR_REFLECTIONS=ON"
    "-DOGRE_BUILD_COMPONENT_OVERLAY=ON"
    "-DOGRE_BUILD_COMPONENT_PROPERTY=ON"
    "-DOGRE_BUILD_COMPONENT_SCENE_FORMAT=ON"
    "-DOGRE_BUILD_COMPONENT_HLMS_UNLIT=ON"
    "-DOGRE_BUILD_TESTS=ON"
    "-DOGRE_BUILD_RENDERSYSTEM_GL3PLUS=ON"
  ]
  ++ lib.optionals stdenv.isDarwin [
    "-DOGRE_USE_NEW_PROJECT_NAME=OFF"
    "-DOGRE_BUILD_RENDERSYSTEM_METAL=ON"
    "-DOGRE_BUILD_LIBS_AS_FRAMEWORKS=OFF"
    "-DOGRE_INSTALL_SAMPLES_SOURCE=OFF"
  ]
  ++ lib.optionals stdenv.isLinux [
    "-DOGRE_USE_NEW_PROJECT_NAME=ON"
    "-DOGRE_INSTALL_SAMPLES_SOURCE=ON"
  ];

  # Use Unix Makefiles instead of Ninja on macOS to avoid build file generation issues
  preConfigure = lib.optionalString stdenv.isDarwin ''
    cmakeFlagsArray+=("-G" "Unix Makefiles")
  '';

  # Fix pkg-config plugindir for Darwin
  # On Darwin, plugins are installed directly in lib/, not lib/OGRE
  postInstall = lib.optionalString stdenv.isDarwin ''
    for pc in $out/lib/pkgconfig/*.pc; do
      substituteInPlace "$pc" \
        --replace 'plugindir=''${libdir}/OGRE' 'plugindir=''${libdir}'
    done
  '';

  nativeBuildInputs = [
    cmake
    doxygen
    graphviz
    cppunit
    vulkan-headers
    shaderc
  ]
  ++ lib.optionals stdenv.isLinux [
    mesa
    ninja
  ];

  buildInputs = [
    freeimage
    freetype
    rapidjson
    zziplib
    SDL2
    tinyxml
    zlib
  ]
  ++ lib.optional (withOpenVR && openvr != null) openvr
  ++ lib.optionals stdenv.isLinux [
    libXaw
    libXrandr
    libGLU
  ]
  ++ lib.optionals (stdenv.isDarwin && darwin != null) [
    ApplicationServices
    Cocoa
    Foundation
    IOKit
    Metal
    OpenGL
  ];

  meta = with lib; {
    description = "3D Object-Oriented Graphics Rendering Engine (aka ogre v2 - scene-oriented, flexible 3D C++ engine)";
    homepage = "https://ogrecave.github.io/ogre-next/api/latest";
    maintainers = with maintainers; [ muellerbernd ];
    platforms = platforms.unix;
    license = licenses.mit;
  };
}
