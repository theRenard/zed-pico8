; PICO-8 highlights for mgmalheiros/tree-sitter-pico8 (queries adapted from
; zed-extensions/lua and the grammar's own highlights, MIT/Apache-2.0)

; Cartridge structure
(cartridge_line) @comment.doc
(version_line "version" @keyword)
(version_line number: (version_number) @number)
(section_marker) @preproc
(opaque_content (data_line) @string.special)

; `#include path`
(include_directive) @preproc

; Keywords
[ "local" "goto" "in" ] @keyword

[
  "do" "else" "elseif" "end" "for" "function" "if" "repeat"
  "return" "then" "until" "while"
  (break_statement)
] @keyword.control

[ "and" "not" "or" ] @keyword.operator

(label_statement) @label

; Operators
(binary_expression operator: _ @operator)
(unary_expression operator: _ @operator)
(compound_assignment_statement operator: _ @operator)
(print_statement "?" @operator)
"=" @operator

[ ";" ":" "," "." ] @punctuation.delimiter
[ "(" ")" "[" "]" "{" "}" ] @punctuation.bracket

; Variables
(identifier) @variable
((identifier) @variable.special (#eq? @variable.special "self"))

((identifier) @constant (#match? @constant "^[A-Z][A-Z_0-9]*$"))
(vararg_expression) @constant
(nil) @constant.builtin
[ (false) (true) ] @boolean

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
    (method_index_expression method: (identifier) @function.method)
  ])

(function_declaration
  name: [
    (identifier) @function.definition
    (dot_index_expression field: (identifier) @function.definition)
    (method_index_expression method: (identifier) @function.method)
  ])

(assignment_statement
  (variable_list
    .
    name: [
      (identifier) @function.definition
      (dot_index_expression field: (identifier) @function.definition)
    ])
  (expression_list
    .
    value: (function_definition)))

(table_constructor
  (field
    name: (identifier) @function.definition
    value: (function_definition)))

; PICO-8 API
(function_call
  name: (identifier) @function.builtin
  (#any-of? @function.builtin "abs" "add" "all" "atan2" "band" "bnot" "bor" "btn" "btnp" "bxor" "camera" "cartdata" "ceil" "chr" "circ" "circfill" "clip" "cls" "cocreate" "color" "coresume" "cos" "costatus" "count" "cstore" "cursor" "del" "deli" "dget" "dset" "extcmd" "fget" "fillp" "flip" "flr" "foreach" "fset" "ipairs" "line" "lshr" "map" "max" "memcpy" "memset" "menuitem" "mget" "mid" "min" "mset" "music" "ord" "pairs" "pal" "palt" "peek" "peek2" "peek4" "pget" "poke" "poke2" "poke4" "print" "printh" "pset" "rect" "rectfill" "reload" "rnd" "rotl" "rotr" "run" "sfx" "sget" "sgn" "shl" "shr" "sin" "split" "spr" "sqrt" "srand" "sset" "sspr" "stat" "stop" "sub" "t" "time" "tline" "tonum" "tostr" "yield" "oval" "ovalfill" "rrect" "rrectfill" "reboot" "pack" "unpack" "select" "type" "setmetatable" "getmetatable" "rawget" "rawset" "rawequal" "rawlen" "assert" "serial" "load" "save" "reset" "ls" "folder" "info" "resume" "next" "trace"))

; PICO-8 callbacks
(function_declaration
  name: (identifier) @function @function.special
  (#any-of? @function.special "_init" "_update" "_update60" "_draw"))

(comment) @comment
(number) @number
(string) @string
(escape_sequence) @string.escape
