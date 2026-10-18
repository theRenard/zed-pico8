# PICO-8 for Zed

A [Zed](https://zed.dev) extension for [PICO-8](https://www.lexaloffle.com/pico-8.php) development, inspired by [pico8vscodeeditor](https://github.com/grumpydev/pico8vscodeeditor).

## Features

- **`.p8` language** with Lua syntax highlighting (tree-sitter-lua), PICO-8 API functions and `_init/_update/_update60/_draw` highlighted, cart section markers (`__lua__`, `__gfx__`, ...) recognised, outline, bracket matching, auto-indent, comment toggling. Files starting with `pico-8 cartridge` are detected automatically.
- **110+ snippets** for the PICO-8 API and common patterns: `game`, `game30`, `pheader`, `pconsts`, `spr`, `rectfill`, `btn`, `cartdata`, `forall`, memory address constants, and more. Optional parameters include their leading comma so you can delete them quickly.
- **PICO-8 language server** ([japhib/pico8-ls](https://github.com/japhib/pico8-ls)): syntax errors, undefined-variable warnings, go to definition, find references, hover docs and signature help for the built-ins, completion, `#include` support. Downloaded automatically.
- **Run / open tasks** for launching PICO-8 from Zed (see `examples/tasks.json`).

## Install

Until published to the Zed registry, install as a dev extension: open Zed, run `zed: install dev extension`, and choose this repository's folder. Requires Rust installed via `rustup`.

## Run PICO-8 from Zed

Zed extensions cannot add commands, so use [tasks](https://zed.dev/docs/tasks). Copy `examples/tasks.json` to `.zed/tasks.json` in your project (or merge into `~/.config/zed/tasks.json`), then run `task: spawn` and pick **PICO-8: run cart**. Set the `PICO8` env var, or edit the command, if `pico8` is not on your PATH (macOS: `/Applications/PICO-8.app/Contents/MacOS/pico8`). `examples/keymap.json` binds it to `cmd-alt-r`.

## Language server

Starts automatically for PICO-8 files. The extension downloads a bundled build of [japhib/pico8-ls](https://github.com/japhib/pico8-ls) from this repo's releases and runs it with Zed's built-in Node, so you need nothing extra. To use your own install instead, put `pico8-ls` on your PATH (e.g. via Mason) or set `lsp.pico8-ls.binary.path` (see `examples/settings.json`).

### Updating the bundled server (maintainers)

Run the **Build language server** workflow (Actions tab) with the upstream tag, e.g. `v0.7.0`. It bundles the server, smoke-tests it, and publishes a release `server-<tag>` with the asset `pico8-ls-server.js`. The extension always downloads the latest release.

## Using it with `.lua` files

`.p8` files open as PICO-8 automatically. Zed cannot tell PICO-8 `.lua` files from other Lua, so to use this extension for `#include`d `.lua` files, add this to your project's `.zed/settings.json`:

```json
{ "file_types": { "PICO-8": ["**/my-cart-folder/**/*.lua"] } }
```

## Known limitations

- Highlighting uses the Lua grammar. PICO-8-only syntax (`!=`, `+=`, `\`, `?"text"`, `@`/`%`/`$` peek operators) and the binary data sections (`__gfx__`, `__map__`, ...) are not Lua, so Zed's error recovery may colour them oddly. A dedicated tree-sitter grammar would fix this; contributions welcome.
- Language server features come from upstream; see [japhib/pico8-ls](https://github.com/japhib/pico8-ls/issues) for what is and isn't supported.

## Development

Snippets are generated: edit `scripts/gen_snippets.py`, then run `python3 scripts/gen_snippets.py`.

## License

MIT. The language server is [japhib/pico8-ls](https://github.com/japhib/pico8-ls) (MIT, by JanPaul Bergeson). Highlight and indent queries are adapted from [zed-extensions/lua](https://github.com/zed-extensions/lua).
