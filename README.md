

# muxel

muxel is an Agent Development Environment (ADE) — a native desktop terminal multiplexer for running several coding agents side by side. It gives you a tiled, tabbed workspace where each pane embeds a real terminal: run Claude Code, opencode, Amp, or plain shells in parallel, track agent status at a glance, and get notified when an agent finishes or needs input.

It's built for driving multiple agents across git worktrees — one window per branch, no tmux keybindings required. See [FEATURES.md](FEATURES.md) for the full feature catalogue.

---

## Install & run

- **Release packages** — the release workflow builds Linux `.deb` / `.rpm` /
  AppImage / `.tar.gz` (x86_64 + aarch64); install the one matching your distro.
- **From source (this machine)** — `scripts/install.sh`: release-builds muxel,
  installs the binary to `~/.local/bin/muxel`, and registers the launcher icon +
  `.desktop` entry pointing at it. Run `muxel` from your launcher, or by name if
  `~/.local/bin` is on your `PATH`.
- **Ad hoc** — run the build-tree binary in place, without installing:
  `cargo run -p muxel` (debug) or `cargo build --release -p muxel &&
  ./target/release/muxel`. It uses your **real** workspace, so it's for quick
  checks; for parallel/sandboxed testing use `scripts/dev.sh` instead.
- **Linux system deps** — a Wayland or X11 stack, `libxkbcommon`,
  fontconfig/freetype, and D-Bus (desktop notifications + tray). `git` and
  `tmux` are optional integrations; each agent CLI is installed separately.

## Dev / main workflow

muxel supports running an installed **main** and a sandboxed **dev** side by
side, so you can develop muxel *inside* muxel:

- **main** — the installed `~/.local/bin/muxel`, using your real workspace.
- **dev** — `scripts/dev.sh`: builds and runs against an isolated sandbox
  (`.muxel-dev/`), so testing never touches the real workspace. Safe to run in
  a pane of the running main. Args go to cargo (`--release`); anything after
  `--` goes to muxel.
- **promote dev → main** — `scripts/promote.sh`: release-builds the current
  tree and atomically swaps `~/.local/bin/muxel` (copy-then-rename, so it's
  safe even while main is running — the running process keeps its old inode).
  Restart main to pick up the new binary; the launcher entry needs no update.
- `MUXEL_BIN_DIR` overrides the install directory for both `install.sh` and
  `promote.sh`.
- Full notes, the two-instance rule, and a cheat sheet:
  [docs/dev-main-workflow.md](docs/dev-main-workflow.md).

## Scripts

| Script | Purpose |
| --- | --- |
| `scripts/dev.sh` | isolated dev instance (sandboxed config/data) |
| `scripts/install.sh` | one-time main install: binary + launcher entry |
| `scripts/promote.sh` | push the current dev tree over the installed main |
| `scripts/install-desktop.sh` | launcher icon + `.desktop` entry only (used by `install.sh`; `MUXEL_EXEC` overrides the Exec path) |
| `scripts/sign-macos.sh` | macOS signing / notarization |
| `scripts/translate.py` | i18n string extraction / translation helper |

---

- **Credits** - I want to give credits to the original Muxel developers for making this ADE that allow people to build off of.

## License

muxel is **dual-licensed**:

- **Open source** — [GNU GPL-3.0](LICENSE): free to use, modify, and
  redistribute, provided any version you distribute is also released under
  GPL-3.0.
- **Commercial** — a separate license from **ProjectHax LLC** for use that can't
  comply with the GPL (e.g. embedding muxel in a closed-source product). See
  [LICENSING.md](LICENSING.md).

By submitting a contribution you agree to the terms in
[CONTRIBUTING.md](CONTRIBUTING.md), which keep both licenses possible.
