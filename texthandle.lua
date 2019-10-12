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

keymap = {
   [1] = 'a',
   [2] = 'b',
   [3] = 'c',
   [4] = 'd',
   [5] = 'e',
   [6] = 'f',
   [7] = 'g',
   [8] = 'h',
   [9] = 'i',
   [10] = 'j',
   [11] = 'k',
   [12] = 'l',
   





function inputBox(x,y,length, fcolor, bcolor)
   local framewidth = 2
   local width = length*8+2*framewidth
   local height = 8 + framewidth
   local x1 = x
   local x2 = x+width
   local y1 = y
   local y2 = y+height
      
   return {
      onFocus = false,
      t = 0,
      handleInput = function()
	 
      end
   }
end

