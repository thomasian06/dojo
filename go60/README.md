# Go60 ZMK keymap

`macos.keymap` is the hand-maintained ZMK keymap source for the MoErgo Go60.
The base layers (Base, Keypad, SymbolNav, Magic, Factory) were originally exported from MoErgo's GO60 Layout Editor web app.
The `td_ctrl` and `td_shift` tap-dance behaviors in the `/* Custom Defined Behaviors */` block were added by hand and are not present in the editor.

We're not using the MoErgo Layout Editor going forward.
Its only import path is an experimental JSON format with no documented schema and no stated guarantee that hand-written Custom Defined Behaviors survive an export/import round-trip.
The DTSI (`.keymap`) export is one-way (editor to file only).
Since our custom tap-dance behaviors live in that file, `macos.keymap` in this repo is now the single source of truth, edited directly.

## Custom behaviors

Both live on the left thumb cluster (`LH_T2` = Shift position, `LH_T3` = Ctrl position in `layer_Base`):

- `td_ctrl` - tap = normal held Ctrl (for chords). Double-tap = sends `Ctrl+b` as a single chord (tmux prefix).
- `td_shift` - tap = normal held Shift (for chords). Double-tap = sticky Alt, applied to the next keypress only (e.g. for AeroSpace's `alt-1`..`alt-9` window bindings without holding Alt).

Tap-dance window is 200ms (`tapping-term-ms`).

### Left trackpad scroll inversion

`&cirque_lh_listener`'s input-processor chains append `&zip_scroll_transform (INPUT_TRANSFORM_Y_INVERT)` after the scroll mapper, since macOS is set to natural scrolling and the trackpad's raw scroll direction needed flipping to match.

### Mouse layer (auto-overlay on right trackpad activity)

`layer_Mouse` (`LAYER_Mouse`) is a temporary layer auto-activated by `zip_temp_layer_mouse` (a `zmk,input-processor-temp-layer`) attached to `&cirque_rh_listener`. It activates whenever the right trackpad starts moving (after 300ms of no keypresses) and drops out 300ms after the trackpad goes idle. It gives the left hand physical mouse buttons while the right hand drives the cursor - for text selection, drag-and-drop, and clicking without lifting off the trackpad:

- `F` (left home) - left click, held for drag/select
- `D` - right click
- `S` - middle click
- `R` - back (`&mkp MB4`)
- `T` - forward (`&mkp MB5`)

`excluded-positions` on `zip_temp_layer_mouse` lists these five keys' positions, so holding one of them (e.g. `F` mid-drag) keeps the layer alive even if the trackpad pauses, instead of the 300ms idle timeout dropping the held click.

Thumbs stay `&trans`, so `td_shift`/`td_ctrl` still work for Shift-click/Ctrl-click while the layer is active.

## Building firmware

This repo only stores the keymap file, not the full ZMK/Zephyr/Nix build graph.
Build against MoErgo's official build workspace:

```bash
# 1. Clone the official build workspace (anywhere outside this repo)
git clone https://github.com/moergo-keyboards/go60-zmk-config.git
cd go60-zmk-config

# 2. Drop this repo's keymap in, renamed to match what the build expects
cp /path/to/dojo/go60/macos.keymap config/go60.keymap

# 3. Build (requires Docker running)
./build.sh
```

`build.sh` builds a Docker image (mirrors `moergo-sc/zmk`, pulls the prebuilt Zephyr/ARM toolchain from Cachix) and runs it, producing `go60.uf2` in the `go60-zmk-config` directory - a combined image for both keyboard halves.

The first build is slow (many minutes - it's downloading the full toolchain from Nix binary caches, not compiling it). Later builds reuse the same Docker image and Nix store and are much faster.

### Flashing

Put each Go60 half into bootloader mode (double-tap reset). It mounts as a USB drive - drag `go60.uf2` onto it. Same file works for both halves.

## Regenerating the visual cheat sheet

Uses [keymap-drawer](https://github.com/caksoylar/keymap-drawer) to render the `.keymap` directly (no MoErgo editor involved). At time of writing, `keymap-drawer`'s ZMK parser needs `tree-sitter<0.22` pinned - the installed version's API is incompatible with newer `tree-sitter`.

```bash
# from inside the go60-zmk-config clone, config/ dir
uvx --from keymap-drawer --with "tree-sitter<0.22" keymap parse -z go60.keymap > go60-keymap.yaml
uvx --from keymap-drawer --with "tree-sitter<0.22" keymap draw go60-keymap.yaml -j info.json > go60-keymap.svg
```

`info.json` (physical key positions) comes from the official build workspace's `config/info.json`.
