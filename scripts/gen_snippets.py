#!/usr/bin/env python3
"""Generate snippets/pico-8.json. Run from the repo root: python3 scripts/gen_snippets.py"""
import json

S = {}
def add(prefix, body, desc):
    S[prefix] = {"prefix": prefix, "body": body if isinstance(body, list) else [body], "description": desc}

# Control flow / basics
add("for", ["for ${1:i}=${2:1},${3:10} do", "\t$0", "end"], "for loop")
add("fors", ["for ${1:i}=${2:1},${3:10},${4:2} do", "\t$0", "end"], "for loop with step")
add("forall", ["for ${1:v} in all(${2:t}) do", "\t$0", "end"], "for v in all(t)")
add("forpair", ["for ${1:k},${2:v} in pairs(${3:t}) do", "\t$0", "end"], "for k,v in pairs(t)")
add("while", ["while ${1:cond} do", "\t$0", "end"], "while loop")
add("repeat", ["repeat", "\t$0", "until ${1:cond}"], "repeat until")
add("if", ["if ${1:cond} then", "\t$0", "end"], "if")
add("ifel", ["if ${1:cond} then", "\t$2", "else", "\t$0", "end"], "if/else")
add("iif", "if (${1:cond}) ${0:stmt}", "PICO-8 single-line if")
add("fun", ["function ${1:name}(${2})", "\t$0", "end"], "function")
add("lfun", ["local function ${1:name}(${2})", "\t$0", "end"], "local function")

# Cart skeletons
add("pheader", ["pico-8 cartridge // http://www.pico-8.com", "version 42", "__lua__", "$0"], "Cartridge header")
add("game", ["function _init()", "\t$0", "end", "", "function _update60()", "\t", "end", "", "function _draw()", "\tcls()", "end"], "60fps game skeleton")
add("game30", ["function _init()", "\t$0", "end", "", "function _update()", "\t", "end", "", "function _draw()", "\tcls()", "end"], "30fps game skeleton")
add("pconsts", ["left,right,up,down,o,x=0,1,2,3,4,5", "black,dark_blue,dark_purple,dark_green,brown,dark_gray,light_gray,white,red,orange,yellow,green,blue,indigo,pink,peach=0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15", "$0"], "Button and colour constants")

# Audio
add("music", "music(${1:n}${2:,fade,mask})", "Play music pattern (-1 stops)")
add("sfx", "sfx(${1:n}${2:,channel,offset,length})", "Play sound effect (-1 stops)")

# Cart data
add("cartdata", "cartdata(\"${1:my_game_id}\")", "Open persistent cart data (once per run)")
add("dget", "dget(${1:index})", "Get number at cart data index")
add("dset", "dset(${1:index},${2:value})", "Store number at cart data index")
add("cstore", "cstore(${1:dest},${2:source},${3:len}${4:,filename})", "Copy RAM to cart/file")
add("reload", "reload(${1:dest},${2:source},${3:len}${4:,filename})", "Load cart data into RAM")

# Coroutines
add("cocreate", "cocreate(${1:func})", "Create coroutine")
add("coresume", "coresume(${1:co}${2:,args})", "Resume coroutine")
add("costatus", "costatus(${1:co})", "'running', 'suspended' or 'dead'")
add("yield", "yield()", "Yield from a coroutine")

# Graphics
add("camera", "camera(${1:x},${2:y})", "Set camera offset")
add("circ", "circ(${1:x},${2:y},${3:r}${4:,col})", "Circle outline")
add("circfill", "circfill(${1:x},${2:y},${3:r}${4:,col})", "Filled circle")
add("clip", "clip(${1:x},${2:y},${3:w},${4:h})", "Set clipping rectangle")
add("cls", "cls(${1:col})", "Clear screen")
add("color", "color(${1:col})", "Set draw colour")
add("cursor", "cursor(${1:x},${2:y}${3:,col})", "Set print cursor")
add("fget", "fget(${1:n}${2:,flag})", "Get sprite flag(s)")
add("fset", "fset(${1:n},${2:flag},${3:val})", "Set sprite flag")
add("flip", "flip()", "Flip back buffer")
add("line", "line(${1:x0},${2:y0}${3:,x1,y1,col})", "Draw line")
add("pal", "pal(${1:c0},${2:c1}${3:,p})", "Swap colour (p: 0 draw, 1 screen)")
add("palt", "palt(${1:col},${2:true})", "Set colour transparency")
add("pget", "pget(${1:x},${2:y})", "Get pixel colour")
add("pset", "pset(${1:x},${2:y}${3:,col})", "Set pixel")
add("print", "print(${1:str}${2:,x,y,col})", "Print text")
add("rect", "rect(${1:x0},${2:y0},${3:x1},${4:y1}${5:,col})", "Rectangle outline")
add("rectfill", "rectfill(${1:x0},${2:y0},${3:x1},${4:y1}${5:,col})", "Filled rectangle")
add("sget", "sget(${1:x},${2:y})", "Get spritesheet pixel")
add("sset", "sset(${1:x},${2:y}${3:,col})", "Set spritesheet pixel")
add("spr", "spr(${1:n},${2:x},${3:y}${4:,w,h,flip_x,flip_y})", "Draw sprite")
add("sspr", "sspr(${1:sx},${2:sy},${3:sw},${4:sh},${5:dx},${6:dy}${7:,dw,dh,flip_x,flip_y})", "Stretch-draw spritesheet region")
add("oval", "oval(${1:x0},${2:y0},${3:x1},${4:y1}${5:,col})", "Oval outline")
add("ovalfill", "ovalfill(${1:x0},${2:y0},${3:x1},${4:y1}${5:,col})", "Filled oval")
add("rrect", "rrect(${1:x},${2:y},${3:w},${4:h},${5:r}${6:,col})", "Rounded rectangle outline")
add("rrectfill", "rrectfill(${1:x},${2:y},${3:w},${4:h},${5:r}${6:,col})", "Filled rounded rectangle")
add("pack", "pack(${1:...})", "Pack values into a table")
add("unpack", "unpack(${1:t}${2:,i,j})", "Unpack table values")
add("select", "select(${1:n},${2:...})", "Select from varargs")
add("fillp", "fillp(${1:pattern})", "Set fill pattern")
add("tline", "tline(${1:x0},${2:y0},${3:x1},${4:y1},${5:mx},${6:my}${7:,mdx,mdy})", "Textured line (map)")

# Input
add("btn", "btn(${1:i}${2:,p})", "Button state (0-5: left,right,up,down,o,x)")
add("btnp", "btnp(${1:i}${2:,p})", "Button pressed (with repeat)")
add("dinput", "poke(0x5f2d,1)", "Enable devkit mouse/keyboard")
add("dkeyp", "stat(30)", "Key pressed (devkit)")
add("dkey", "stat(31)", "Key character (devkit)")
add("dmousex", "stat(32)", "Mouse X")
add("dmousey", "stat(33)", "Mouse Y")
add("dmousebtn", "stat(34)", "Mouse button bitfield")
add("dmousewheel", "stat(36)", "Mouse wheel")

# Map
add("map", "map(${1:cel_x},${2:cel_y},${3:sx},${4:sy},${5:cel_w},${6:cel_h}${7:,layer})", "Draw map region")
add("mget", "mget(${1:x},${2:y})", "Get map tile")
add("mset", "mset(${1:x},${2:y},${3:v})", "Set map tile")

# Math
for name, args, d in [
    ("abs","x","Absolute value"),("atan2","dx,dy","Angle 0-1 from dx,dy"),("band","x,y","Bitwise and"),
    ("bnot","x","Bitwise not"),("bor","x,y","Bitwise or"),("bxor","x,y","Bitwise xor"),
    ("flr","x","Round down"),("ceil","x","Round up"),("min","x,y","Minimum"),("max","x,y","Maximum"),
    ("mid","x,y,z","Middle value / clamp"),("srand","seed","Seed rnd"),("rnd","x","Random 0 <= n < x"),
    ("sgn","x","Sign (-1 or 1)"),("shl","x,n","Shift left"),("shr","x,n","Shift right"),
    ("sin","x","Sine (0-1, inverted)"),("cos","x","Cosine (0-1)"),("sqrt","x","Square root"),
]:
    parts = args.split(",")
    add(name, f"{name}(" + ",".join(f"${{{i+1}:{p}}}" for i, p in enumerate(parts)) + ")", d)
add("round", "flr(${1:x}+0.5)", "Round to nearest")

# Memory
add("memcpy", "memcpy(${1:dest},${2:src},${3:len})", "Copy memory")
add("memset", "memset(${1:dest},${2:val},${3:len})", "Fill memory")
add("peek", "peek(${1:addr})", "Read byte")
add("poke", "poke(${1:addr},${2:val})", "Write byte")
add("gpior", "peek(0x5f80+${1:pin})", "Read GPIO pin")
add("gpiow", "poke(0x5f80+${1:pin},${2:val})", "Write GPIO pin")
for n, a, d in [("memgfx","0x0000","Sprite sheet"),("memmap","0x2000","Map"),("memgfxprops","0x3000","Sprite flags"),
                ("memsong","0x3100","Music"),("memsfx","0x3200","SFX"),("memud","0x4300","User data"),
                ("memcd","0x5e00","Persistent cart data"),("memds","0x5f00","Draw state"),
                ("memgpio","0x5f80","GPIO"),("memscr","0x6000","Screen")]:
    add(n, a, f"Base address: {d}")

# Tables / strings / system
add("add", "add(${1:t},${2:v})", "Append to table")
add("del", "del(${1:t},${2:v})", "Delete value from table")
add("deli", "deli(${1:t}${2:,i})", "Delete by index")
add("count", "count(${1:t})", "Count items")
add("foreach", ["foreach(${1:t},function(${2:v})", "\t$0", "end)"], "foreach callback")
add("sub", "sub(${1:str},${2:from}${3:,to})", "Substring")
add("tostr", "tostr(${1:v})", "To string")
add("tonum", "tonum(${1:str})", "To number")
add("split", "split(${1:str}${2:,sep,convert})", "Split string")
add("stat", "stat(${1:n})", "System status")
add("printh", "printh(${1:str})", "Print to host console")
add("menuitem", "menuitem(${1:index},${2:\"label\"},${3:function(b) $0 end})", "Pause menu item")
add("time", "time()", "Seconds since start")

with open("snippets/pico-8.json", "w") as f:
    json.dump(S, f, indent=2)
    f.write("\n")
print(len(S), "snippets")
