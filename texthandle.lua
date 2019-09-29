-- title : text handler
-- author : yunoinsky
-- descrp : A trial for text input handler
-- input : keyboard
-- script : lua


function TIC()
   cls()
   a = key(7)
   print(a,11,31, 1, false)
   
end



function inputBox(x,y,length, fcolor, bcolor)
   local framewidth = 2
   local width = length*8+2*framewidth
   local height = 8 + framewidth
   local x1 = x
   local x2 = x+width
   local y1 = y
   local y2 = y+height
      
   return {
      onFocus = false,  --if the input box get the focus
      t = 0,
      handleInput = function()
      end
   }
end

