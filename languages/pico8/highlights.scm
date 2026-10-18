; PICO-8 highlights, adapted from zed-extensions/lua (MIT/Apache-2.0)

[ "local" ] @keyword

[
  "do" "else" "elseif" "end" "for" "function" "goto" "if" "in"
  "repeat" "return" "then" "until" "while"
  (break_statement)
] @keyword.control

[ "and" "not" "or" ] @keyword.operator

[
  "+" "-" "*" "/" "%" "^" "#" "==" "~=" "<=" ">=" "<" ">" "="
  "&" "~" "|" "<<" ">>" "//" ".."
] @operator

[ ";" ":" "," "." ] @punctuation.delimiter
[ "(" ")" "[" "]" "{" "}" ] @punctuation.bracket

(identifier) @variable
((identifier) @variable.special (#eq? @variable.special "self"))

((identifier) @constant (#match? @constant "^[A-Z][A-Z_0-9]*$"))
(vararg_expression) @constant
(nil) @constant.builtin
[ (false) (true) ] @boolean

; Cart section markers (__lua__, __gfx__, ...)
((identifier) @preproc
  (#match? @preproc "^__(lua|gfx|gff|label|map|sfx|music)__$"))

; Tables
(field name: (identifier) @property)
(dot_index_expression field: (identifier) @property)
(table_constructor [ "{" "}" ] @constructor)

; Functions
(parameters (identifier) @variable.parameter)

(function_call
  name: [
    (identifier) @function
    (dot_index_expression field: (identifier) @function)
  ])

(function_declaration
  name: [
    (identifier) @function.definition
    (dot_index_expression field: (identifier) @function.definition)
  ])

(method_index_expression method: (identifier) @function.method)

; PICO-8 API
(function_call
  name: (identifier) @function.builtin
  (#any-of? @function.builtin "abs" "add" "all" "atan2" "band" "bnot" "bor" "btn" "btnp" "bxor" "camera" "cartdata" "ceil" "chr" "circ" "circfill" "clip" "cls" "cocreate" "color" "coresume" "cos" "costatus" "count" "cstore" "cursor" "del" "deli" "dget" "dset" "extcmd" "fget" "fillp" "flip" "flr" "foreach" "fset" "ipairs" "line" "lshr" "map" "max" "memcpy" "memset" "menuitem" "mget" "mid" "min" "mset" "music" "ord" "pairs" "pal" "palt" "peek" "peek2" "peek4" "pget" "poke" "poke2" "poke4" "print" "printh" "pset" "rect" "rectfill" "reload" "rnd" "rotl" "rotr" "run" "sfx" "sget" "sgn" "shl" "shr" "sin" "split" "spr" "sqrt" "srand" "sset" "sspr" "stat" "stop" "sub" "t" "time" "tline" "tonum" "tostr" "yield"))

; PICO-8 callbacks
(function_declaration
  name: (identifier) @function @function.special
  (#any-of? @function.special "_init" "_update" "_update60" "_draw"))

(comment) @comment
(number) @number
(string) @string
(escape_sequence) @string.escape
