{
  lib,
  stdenv,
  symlinkJoin,
  ignition,
  ignition-cmake ? ignition.cmake,
  ignition-common ? ignition.common,
  ignition-math ? ignition.math,
  ignition-transport ? ignition.transport,
  ignition-msgs ? ignition.msgs,
  ignition-fuel-tools ? ignition.fuel-tools,
  ignition-plugin ? ignition.plugin,
  ignition-physics ? ignition.physics,
  ignition-rendering ? ignition.rendering,
  ignition-gui ? ignition.gui,
  ignition-sensors ? ignition.sensors,
  ignition-tools ? ignition.tools,
  ignition-utils ? ignition.utils,
  ignition-sim ? ignition.sim,
  sdformat ? ignition.sdformat,
  makeWrapper,
  qtbase,
  qtdeclarative,
  qtquickcontrols,
  qtquickcontrols2,
  qtgraphicaleffects,
  wrapQtAppsHook,
  majorVersion ? "8",
  ...
}:
symlinkJoin {
  name = "gz-sim_${majorVersion}";

  paths = [
    ignition-cmake
    ignition-common
    ignition-msgs
    ignition-plugin
    ignition-utils
    ignition-rendering
    ignition-sensors
    ignition-tools
    ignition-math
    ignition-transport
    ignition-fuel-tools
    ignition-physics
    ignition-gui
    ignition-sim
  ];
  buildInputs = [ makeWrapper ];
  nativeBuildInputs = [ wrapQtAppsHook ];

  # Make Qt packages available for QML import path
  qtWrapperArgs = [
    "--prefix QML2_IMPORT_PATH : ${qtbase}/${qtbase.qtQmlPrefix}"
    "--prefix QML2_IMPORT_PATH : ${qtdeclarative.bin}/${qtbase.qtQmlPrefix}"
    "--prefix QML2_IMPORT_PATH : ${qtquickcontrols}/${qtbase.qtQmlPrefix}"
    "--prefix QML2_IMPORT_PATH : ${qtquickcontrols2.bin}/${qtbase.qtQmlPrefix}"
    "--prefix QML2_IMPORT_PATH : ${qtgraphicaleffects}/${qtbase.qtQmlPrefix}"
  ];

  postBuild =
    if (lib.versionAtLeast majorVersion "8") then
      ''
        wrapProgram $out/bin/gz \
          --set GZ_CONFIG_PATH "$out/share/gz" \
          --prefix QML2_IMPORT_PATH : "${qtbase}/${qtbase.qtQmlPrefix}" \
          --prefix QML2_IMPORT_PATH : "${qtdeclarative.bin}/${qtbase.qtQmlPrefix}" \
          --prefix QML2_IMPORT_PATH : "${qtquickcontrols}/${qtbase.qtQmlPrefix}" \
          --prefix QML2_IMPORT_PATH : "${qtquickcontrols2.bin}/${qtbase.qtQmlPrefix}" \
          --prefix QML2_IMPORT_PATH : "${qtgraphicaleffects}/${qtbase.qtQmlPrefix}"
      ''
    else
      ''
        wrapProgram $out/bin/ign \
          --set IGN_CONFIG_PATH "$out/share/ignition" \
          --prefix QML2_IMPORT_PATH : "${qtbase}/${qtbase.qtQmlPrefix}" \
          --prefix QML2_IMPORT_PATH : "${qtdeclarative.bin}/${qtbase.qtQmlPrefix}" \
          --prefix QML2_IMPORT_PATH : "${qtquickcontrols}/${qtbase.qtQmlPrefix}" \
          --prefix QML2_IMPORT_PATH : "${qtquickcontrols2.bin}/${qtbase.qtQmlPrefix}" \
          --prefix QML2_IMPORT_PATH : "${qtgraphicaleffects}/${qtbase.qtQmlPrefix}"
      '';
}
