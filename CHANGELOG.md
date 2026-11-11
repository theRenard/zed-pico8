# Changelog

## 0.3.0
- Switch from tree-sitter-lua to a PICO-8 grammar (fork of mgmalheiros/tree-sitter-pico8). PICO-8 syntax (`!=`, `+=`, `..=`, `\`, `?`, shorthand `if`), `\^` string escapes, `#include` lines and the `.p8` cart sections now parse; highlighting no longer breaks for the rest of the file. Headerless `.lua` files (`#include`d code) are supported.

## 0.2.2
- Fix highlighting breaking after strings with PICO-8 control codes such as `"\^:..."` (grammar fork accepts PICO-8 escapes).

## 0.2.1
- Download the language server directly from japhib/pico8-ls releases (`pico8-ls-server.js`); remove the local build workflow.

## 0.2.0
- Replace LuaLS with the PICO-8-aware language server japhib/pico8-ls (bundled and published by a GitHub Actions workflow).

## 0.1.0
- Initial release: `.p8` language, Lua-based highlighting with PICO-8 API/callback captures, 100+ API snippets, opt-in LuaLS integration, example tasks.
