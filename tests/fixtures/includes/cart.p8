pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
-- include resolution: #include only works in the cart itself, so every file is
-- listed here, in dependency order. Later files use functions and globals from earlier ones.
#include lua/a.lua
#include lua/util/v2.lua
#include lua/b.lua
#include lua/main.lua
__gfx__
00000000
