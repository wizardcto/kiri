# Kiri Linux AppImage

Portable builds alongside the `.deb` and `.rpm`, produced by `packaging/linux/build.sh`
when `appimagetool` is available (downloaded automatically by
`fetch-appimage-tools.sh`).

## What is inside

Same payloads as the packages:

- **kiri-lite-\*.AppImage** — static `kiri` and `kiri-init` (musl).
- **kiri-\*.AppImage** — engine, bundled docker CLI, Compose and buildx, and the
  GTK window when `libwebkit2gtk-4.1-dev` was present at build time.

The AppImage does **not** install `kiri.service`, polkit actions, or the `kiri` group.
Use the `.deb` or `.rpm` for a normal system install with systemd and software centers.

## Running

```sh
chmod +x kiri-*.AppImage
./kiri-1.2.3-x86_64.AppImage --version
./kiri-lite-1.2.3-x86_64.AppImage daemon   # needs root for /run/kiri/docker.sock
./kiri-1.2.3-x86_64.AppImage ui            # window, when bundled
```

Engine setup on a host still needs root (group, socket, optional systemd), e.g.
`sudo ./kiri-….AppImage host-access "$USER"` — same as an installed `kiri`.

## Limitations

- No automatic systemd unit; start the daemon manually or use `host-access` after install-like setup.
- Default docker socket remains `unix:///run/kiri/docker.sock` (not relocated into the AppImage mount).
- Container work needs normal Linux privileges (namespaces, cgroups); AppImage does not grant them.
- FUSE inside containers follows the host kernel; the AppImage does not bundle a kernel or VM.