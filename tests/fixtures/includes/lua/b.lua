-- uses a.lua and util/v2.lua (included earlier by the cart; .lua files cannot #include)
function b_fn()
 counter+=1
 return a_fn(counter),v2(counter,counter)
end
