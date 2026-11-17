#!/bin/bash
# appimagetool and linuxdeploy for packaging/linux/build.sh (window builds bundle
# GTK/WebKit with linuxdeploy -e).
#   packaging/linux/fetch-appimage-tools.sh <cache-dir> [x86_64|aarch64]
# Prints one line: appimagetool linuxdeploy (absolute paths).
set -euo pipefail
cache=$(mkdir -p "$1" && cd "$1" && pwd)
arch=${2:-x86_64}
case $arch in
  x86_64) ;;
  aarch64) ;;
  *) echo "arch must be x86_64 or aarch64" >&2; exit 1 ;;
esac
# Pinned continuous appimagetool (AppImage/appimagetool).
appimage_url="https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-${arch}.AppImage"
appimage_sum_x86_64=e8c1169c4af66c3184d7ee110713d4be04befe671fa358e2c1591ee840553b03
appimage_sum_aarch64=d6a061996de690434996c2a523eafedd0a23780aaf02d69ce364537e71607e94
eval "appimage_sum=\$appimage_sum_${arch}"
appimagetool=$cache/appimagetool-$arch
if [ ! -x "$appimagetool" ]; then
  curl -fsSL --proto '=https' --proto-redir '=https' --retry 3 -o "$appimagetool.part" "$appimage_url"
  echo "$appimage_sum  $appimagetool.part" | sha256sum -c --quiet -
  chmod +x "$appimagetool.part"
  mv "$appimagetool.part" "$appimagetool"
fi
# linuxdeploy 1-alpha-20251107-1: bundles glibc-linked executables and their .so deps.
deploy_ver=1-alpha-20251107-1
deploy_url="https://github.com/linuxdeploy/linuxdeploy/releases/download/${deploy_ver}/linuxdeploy-${arch}.AppImage"
deploy_sum_x86_64=c20cd71e3a4e3b80c3483cef793cda3f4e990aca14014d23c544ca3ce1270b4d
deploy_sum_aarch64=
eval "deploy_sum=\$deploy_sum_${arch}"
deploy=$cache/linuxdeploy-$arch
if [ ! -x "$deploy" ]; then
  curl -fsSL --proto '=https' --proto-redir '=https' --retry 3 -o "$deploy.part" "$deploy_url"
  if [ -n "$deploy_sum" ]; then
    echo "$deploy_sum  $deploy.part" | sha256sum -c --quiet -
  fi
  chmod +x "$deploy.part"
  mv "$deploy.part" "$deploy"
fi
echo "$appimagetool $deploy"