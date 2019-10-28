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

function frame(name,window)
   subframe
end


-- window is the basic container for our ui system, which refer to a scene with multiple frames
function window(name, director)
   active_status = false
   frames = {}
   
end



