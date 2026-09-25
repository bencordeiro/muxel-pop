#!/usr/bin/env bash
# One-time install of muxel as this user's "main" app:
#   1. release-build the binary
#   2. install it to ~/.local/bin/muxel (atomic swap; safe while main runs)
#   3. register the launcher icon + .desktop entry pointing at that path
#
#   scripts/install.sh
#   MUXEL_BIN_DIR=/opt/bin scripts/install.sh   # override the install dir
#
# Day-to-day afterwards:
#   scripts/dev.sh      # isolated dev instance (safe inside a main pane)
#   scripts/promote.sh  # push the dev tree over the installed main
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
# Copy-then-rename: overwriting a *running* executable in place fails with
# ETXTBSY, but a rename swaps the directory entry and leaves the running
# process on its old inode.
tmp="$(mktemp "$dest_dir/.muxel.XXXXXX")"
trap 'rm -f "$tmp"' EXIT
cp "$repo_root/target/release/muxel" "$tmp"
chmod +x "$tmp"
mv -f "$tmp" "$dest"
trap - EXIT
echo "installed binary: $dest" >&2

case ":$PATH:" in
*":$dest_dir:"*) ;;
*) echo "note: $dest_dir is not on your PATH — add it to run 'muxel' by name." >&2 ;;
esac

MUXEL_EXEC="$dest" "$repo_root/scripts/install-desktop.sh" --no-build
