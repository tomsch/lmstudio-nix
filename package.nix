{
  lib,
  appimageTools,
  fetchurl,
  stdenv,
}:
let
  pname = "lmstudio";
  version = "0.4.1-1";

  src = fetchurl {
    url = "https://installers.lmstudio.ai/linux/x64/${version}/LM-Studio-${version}-x64.AppImage";
    hash = "sha256-0Y4XjK3vfWeY8Z5tQfM6KX4modKFCRy8MNqCUtGKRvA=";
  };

  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    # Install desktop file
    install -Dm644 ${appimageContents}/lm-studio.desktop $out/share/applications/lm-studio.desktop
    substituteInPlace $out/share/applications/lm-studio.desktop \
      --replace-fail "Exec=AppRun" "Exec=${pname}"

    # Install icons
    for size in 16 32 48 64 128 256 512 1024; do
      if [ -f "${appimageContents}/usr/share/icons/hicolor/''${size}x''${size}/apps/lm-studio.png" ]; then
        install -Dm644 "${appimageContents}/usr/share/icons/hicolor/''${size}x''${size}/apps/lm-studio.png" \
          "$out/share/icons/hicolor/''${size}x''${size}/apps/lm-studio.png"
      fi
    done

    # Fallback: copy icon from root if exists
    if [ -f "${appimageContents}/lm-studio.png" ]; then
      install -Dm644 "${appimageContents}/lm-studio.png" "$out/share/icons/hicolor/256x256/apps/lm-studio.png"
    fi

    # lms cli tool
    install -m 755 ${appimageContents}/resources/app/.webpack/lms $out/bin/

    patchelf --set-interpreter "${stdenv.cc.bintools.dynamicLinker}" \
    --set-rpath "${lib.getLib stdenv.cc.cc}/lib:${lib.getLib stdenv.cc.cc}/lib64:$out/lib:${
      lib.makeLibraryPath [ (lib.getLib stdenv.cc.cc) ]
    }" $out/bin/lms
  '';

  meta = {
    description = "Discover, download, and run local LLMs";
    homepage = "https://lmstudio.ai";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "lmstudio";
  };
}
