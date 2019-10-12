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



-- the single-line inputbox, it will create and return a new inputBox object
-- x, y: the topleft point coordinate of the inputBox
-- length: the maxlength of the input string
--


function inputBox(x_lt,y_lt,length, f_color, b_color)
   local ipb = {
      x = x_lt,
      y = y_lt,
      len = length,
      fcolor = f_color,
      bcolor = b_color,
      onfocus = false,
      buf = ""
   }
   function ipb:handleInput()
      
   end
end

