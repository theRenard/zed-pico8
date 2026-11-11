# Tests

Fixtures for the PICO-8 grammar and language server. Everything lives in this repo, so the checks do not depend on anyone's carts.

## Fixtures

- `fixtures/grammar/` – one small file per construct group. Each must parse with no error nodes.
  - `operators.lua` – `!=`, compound assignments (`+=` … `>><=`), `\`, bit operators, `@ % $` peeks.
  - `shorthand.lua` – shorthand `if` / `while`, `?` print.
  - `strings.lua` – Lua escapes and PICO-8 control codes (`\^:`, `\^w`, `\#`, `\|`, `\+`, `\-`, `\f`), long strings.
  - `numbers.lua` – hex/binary literals with fractions.
  - `control.lua` – tables, methods, loops, `goto`, coroutines, varargs.
  - `cart.p8` – full cart with header and all data sections.
- `fixtures/includes/` – a cart that `#include`s several `.lua` files in dependency order (including one in a subfolder). The files use each other's functions and globals. PICO-8 only allows `#include` in the cart, so the `.lua` files contain none. The language server must report **no** diagnostics.

## Running

```sh
# grammar: pass a checkout of the grammar fork (needs tree-sitter or npx)
tests/check-grammar.sh /path/to/tree-sitter-pico8

# includes: pass the pico8-ls server bundle (pico8-ls-server.js from the japhib/pico8-ls release)
node tests/check-includes.js /path/to/pico8-ls-server.js
```

Both exit non-zero on failure. Add a fixture whenever a new construct or include pattern breaks highlighting or produces a false warning.
