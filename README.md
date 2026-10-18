# PICO-8 for Zed

A [Zed](https://zed.dev) extension for [PICO-8](https://www.lexaloffle.com/pico-8.php) development, inspired by [pico8vscodeeditor](https://github.com/grumpydev/pico8vscodeeditor).

## Features

- **`.p8` language** with Lua syntax highlighting (tree-sitter-lua), PICO-8 API functions and `_init/_update/_update60/_draw` highlighted, cart section markers (`__lua__`, `__gfx__`, ...) recognised, outline, bracket matching, auto-indent, comment toggling. Files starting with `pico-8 cartridge` are detected automatically.
- **110+ snippets** for the PICO-8 API and common patterns: `game`, `game30`, `pheader`, `pconsts`, `spr`, `rectfill`, `btn`, `cartdata`, `forall`, memory address constants, and more. Optional parameters include their leading comma so you can delete them quickly.
- **Optional Lua language server** (LuaLS) preconfigured for PICO-8 (`!=`, `+=` etc. accepted, PICO-8 globals defined). Opt-in, see below.
- **Run / open tasks** for launching PICO-8 from Zed (see `examples/tasks.json`).

## Install

Until published to the Zed registry, install as a dev extension: open Zed, run `zed: install dev extension`, and choose this repository's folder. Requires Rust installed via `rustup`.

## Run PICO-8 from Zed

Zed extensions cannot add commands, so use [tasks](https://zed.dev/docs/tasks). Copy `examples/tasks.json` to `.zed/tasks.json` in your project (or merge into `~/.config/zed/tasks.json`), then run `task: spawn` and pick **PICO-8: run cart**. Set the `PICO8` env var, or edit the command, if `pico8` is not on your PATH (macOS: `/Applications/PICO-8.app/Contents/MacOS/pico8`). `examples/keymap.json` binds it to `cmd-alt-r`.

## Language server (opt-in)

Add to your Zed settings (see `examples/settings.json`):

```json
{
  "languages": { "PICO-8": { "language_servers": ["pico8-luals", "..."] } }
}
```

It uses `lua-language-server` from your PATH, or downloads it automatically. Override with `lsp.pico8-luals.binary.path`, or replace the defaults via `lsp.pico8-luals.settings`.

## Known limitations

- Highlighting uses the Lua grammar. PICO-8-only syntax (`!=`, `+=`, `\`, `?"text"`, `@`/`%`/`$` peek operators) and the binary data sections (`__gfx__`, `__map__`, ...) are not Lua, so Zed's error recovery may colour them oddly. A dedicated tree-sitter grammar would fix this; contributions welcome.
- The language server sees the whole `.p8` file, so the header and data sections can produce syntax diagnostics. Keeping code in `.lua` files pulled in with `#include` avoids this.

## Development

Snippets are generated: edit `scripts/gen_snippets.py`, then run `python3 scripts/gen_snippets.py`.

## License

MIT. Highlight and indent queries are adapted from [zed-extensions/lua](https://github.com/zed-extensions/lua).
