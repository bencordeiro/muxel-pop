#!/usr/bin/env bash
# Push the current dev tree over the installed "main" muxel:
# release-build, then atomically swap ~/.local/bin/muxel.
#
#   scripts/promote.sh
#   MUXEL_BIN_DIR=/opt/bin scripts/promote.sh   # match a custom install dir
#
# Safe to run from inside a running main (e.g. a muxel pane): the swap is a
# rename, so the running process keeps its old inode. Restart main (quit +
# relaunch) to pick up the new binary. Dev instances (scripts/dev.sh) and the
# dev sandbox are untouched. The launcher entry needs no update — its Exec
# path is stable.
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
dest_dir="${MUXEL_BIN_DIR:-$HOME/.local/bin}"
dest="$dest_dir/muxel"

echo "building release binary…" >&2
# A running main may still hold target/release/muxel (the old launcher pointed
# there). Unlink it first — the running process keeps its inode — or rustc's
# write fails with ETXTBSY.
rm -f "$repo_root/target/release/muxel"
(cd "$repo_root" && cargo build --release -p muxel)

mkdir -p "$dest_dir"
# Copy-then-rename: see install.sh — in-place overwrite of a running binary
# fails with ETXTBSY, rename does not.
tmp="$(mktemp "$dest_dir/.muxel.XXXXXX")"
trap 'rm -f "$tmp"' EXIT
cp "$repo_root/target/release/muxel" "$tmp"
chmod +x "$tmp"
mv -f "$tmp" "$dest"
trap - EXIT

echo "main updated: $dest — restart muxel to run it." >&2
