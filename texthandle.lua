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

function get_kbd_char()
   A="abcdefghijklmnopqrstuvwxyz0123456789-=[]\\;'`,./ "
   S="ABCDEFGHIJKLMNOPQRSTUVWXYZ)!@#$%^&*(_+{}|:\"~<>? "
   for i=0,3 do
      local c=peek(0xff88+i)
      if c>0 and c<=#A and keyp(c,20,3) then
	 return key(64)and S:sub(c,c)or A:sub(c,c)
      end
   end
   return nil
end


-- the single-line inputbox, it will create and return a new inputBox object
-- x, y: the topleft point coordinate of the inputBox
-- length: the maxlength of the input string
--
timer_CMD = {
   run = 0,
   stop = 1,
   reset = 2
}

function timer(time, isLoop)
   t = time
   run_status = true 
   return function(command)
      if t == 0 then
	 if isLoop then
	    t = time
	 else
	    run_status = false
	 end
      end
      if run_status then
	 t = t-1
      end
      return t
      if command == timer_CMD.run then
	 run_status = true
      elseif command == timer_CMD.stop then
	 run_status = false
      elseif command == timer_CMD.reset then
	 t = time
      end      
   end
end

function inputBox(x_lt,y_lt,length, f_color, b_color, hintword)

   x = x_lt,
   y = y_lt,
   len = length,
   fcolor = f_color,
   bcolor = b_color,
   onfocus = false,
   buf = "",
   hint = hintword or ""

   return {handleInput=function()
      if self.onfocus then
	 c = get_kbd_char()
	 if c then
	    self.buf = self.buf .. c
	 end
      end
   end,
   function()

   end,
   function update()
      
   end
   
end

