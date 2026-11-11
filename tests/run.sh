#!/usr/bin/env bash
# Run all checks: grammar parse, language server on the includes fixture, and on the grammar fixtures.
# Usage: tests/run.sh /path/to/tree-sitter-pico8-checkout [pico8-ls version, default v0.8.0]
set -u
GRAMMAR="${1:?usage: $0 <path to tree-sitter-pico8 checkout> [pico8-ls version]}"
VERSION="${2:-v0.8.0}"
HERE="$(cd "$(dirname "$0")" && pwd)"
TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT
gh release download "$VERSION" --repo japhib/pico8-ls --pattern pico8-ls-server.js --dir "$TMP" >/dev/null \
  || { echo "could not download pico8-ls $VERSION"; exit 2; }
SERVER="$TMP/pico8-ls-server.js"
fail=0
echo "== grammar (tree-sitter)";            "$HERE/check-grammar.sh" "$GRAMMAR" | grep -v -E "^(Warning|Please|configuration|language)" || true
[ "${PIPESTATUS[0]}" -eq 0 ] || fail=1
echo "== language server: includes";        node "$HERE/check-includes.js" "$SERVER"                       || fail=1
echo "== language server: grammar fixtures"; node "$HERE/check-includes.js" "$SERVER" grammar control.lua  || fail=1
[ $fail -eq 0 ] && echo "ALL OK" || echo "FAILURES"
exit $fail
