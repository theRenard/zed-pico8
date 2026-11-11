-- PICO-8 shorthand statements
x=0
y=0
obj={update=function() end}
if (x==1) y=2
if (x==1) y=2 else y=3
if (btn(0)) x-=1
if (btn(1)) x+=1
while (x<10) x+=1
?"hello"
?x,1,2
if (x>0) obj:update()
if (x>0) return
