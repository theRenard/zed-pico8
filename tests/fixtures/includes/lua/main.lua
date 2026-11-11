-- uses everything defined above; must report no undefined variables
function _update()
 local p=v2(1,2)
 b_fn()
 counter+=p.x
end

function _draw()
 cls()
 print(a_fn(counter))
end
