#!/bin/zsh
# Double-click in Finder: starts Beam (Art-Net visualizer) with the MiniDesk rig.
cd "$(dirname "$0")"
export PATH="/usr/local/bin:/opt/homebrew/bin:$PATH"
if lsof -nP -iUDP:6454 >/dev/null 2>&1; then
  echo "Something already listens on Art-Net (UDP 6454) — Beam is probably running."
  exit 0
fi
mkdir -p tools/dev/out
if [ ! -d node_modules ]; then
  echo "Installing Beam's dependencies (npm ci, about a minute; node_modules is regenerable and was cleaned)…"
  npm ci || { echo "npm ci failed"; exit 1; }
fi
nohup npx electron-vite dev -- "$PWD/minidesk-test/MiniDesk.beam" > tools/dev/out/app.log 2>&1 &
echo "Beam starting… (log: $PWD/tools/dev/out/app.log). You can close this window."
