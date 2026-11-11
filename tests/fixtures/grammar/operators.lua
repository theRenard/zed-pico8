-- PICO-8 operators that plain Lua cannot parse
x=1
y=2
if x!=y then x+=1 end
x-=1
x*=2
x/=2
x\=2
x%=3
x..="a"
x^=2
x&=1
x|=1
x^^=1
x<<=1
x>>=1
x>>>=1
x<<>=1
x>><=1
a=x\2
b=x^^y
c=x<<>1
d=x>><1
e=x>>>1
f=x<<2
g=@0x5f00
h=%0x5f00
i=$0x5f00
j=~x
k=-x
l=#"abc"
if x~=y and x!=y or not x then y=1 end
