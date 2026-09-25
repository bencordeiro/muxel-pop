# Known issues

Tracked-but-unfixed problems. Pick these up when it makes sense; remove an
entry once it's fixed and released.

## Terminal glyph spacing / malformed rendering on Arch Linux

- **Status:** open — noted, deliberately not fixed yet (noted during the
  v0.3.0 release).
- **Report:** on Arch Linux the embedded terminal panes show weird letter
  spacing and malformed-looking rendering. Everything else in the app works
  normally there.
- **Symptoms:** incorrect glyph advance / cell geometry in terminal panes;
  output can look misaligned or broken even though the underlying PTY session
  is fine.
- **Suspected area (undiagnosed):** terminal font metrics / fontconfig
  resolution on Arch (default monospace font or fallback chain differing from
  the Pop!_OS dev machine), or the GPUI terminal renderer's glyph-advance
  math. No root-cause work done yet.
- **Not reproduced:** on the primary dev machine (Pop!_OS) the same builds
  render correctly.
- **Open questions to answer when picking this up:**
  - Which package format was used on Arch (AppImage / .tar.gz / source build)?
  - Which terminal font was configured / what does fontconfig resolve
    `monospace` to on that machine?
  - Which WM/compositor (X11 or Wayland)?
  - Does changing Settings → terminal font family change the malformed look?
- **First steps when fixing:** compare `fc-match monospace` output Arch vs
  Pop!_OS; log the resolved terminal font family + size at pane spawn; capture
  a screenshot pair; check the terminal element's cell-width computation
  against the font's measured advance.
