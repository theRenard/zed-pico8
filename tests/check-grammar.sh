#!/usr/bin/env bash
# Parse every grammar fixture with the PICO-8 tree-sitter grammar; fail if any has error nodes.
# Usage: tests/check-grammar.sh /path/to/tree-sitter-pico8-checkout
set -u
GRAMMAR="${1:?usage: $0 <path to tree-sitter-pico8 checkout>}"
HERE="$(cd "$(dirname "$0")" && pwd)"
TS="tree-sitter"; command -v tree-sitter >/dev/null || TS="npx -y tree-sitter-cli@0.25"
fail=0
cd "$GRAMMAR" || exit 2
for f in "$HERE"/fixtures/grammar/*; do
  if out=$($TS parse "$f" 2>&1) && ! grep -qE "\(ERROR|\(MISSING" <<<"$out"; then
    echo "ok    ${f#$HERE/}"
  else
    echo "FAIL  ${f#$HERE/}"; grep -E "\(ERROR|\(MISSING" <<<"$out" | head -3 | sed 's/^/        /'; fail=1
  fi
done
exit $fail
