-- general Lua structure
local t={1,2,3,n="x",[4]=5,f=function(a,b) return a+b end}
function t.new(o) return setmetatable(o or {},{__index=t}) end
function t:method(...) return select("#",...) end
local function loc(a,b,...) local n=a+b return n end
for i=1,#t do t[i]+=1 end
for k,v in pairs(t) do print(k) end
repeat t.n=1 until t.n==1
while true do break end
for i=3,1,-1 do goto skip ::skip:: end
local co=cocreate(function() yield() end)
-- function name that is defined later and used before
use_later()
function use_later() end
