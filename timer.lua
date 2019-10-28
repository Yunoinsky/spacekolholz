-- The simple timer
-- Author: Yunoinsky
-- timer(time, isLoop) to create and return a timer function
-- time: int,  the frame number of each timer loop
-- isLoop: bool, is the timer can loop itself

local P = {
   run = 0,
   stop = 1,
   reset = 2
}

if _REQUIREDNAME == nil then
   timer = P
else
   _G[_REQUIREDNAME] = P
end

function P.timer(time, isLoop)
   if type(time)~="number" or time < 0 then
      error("ERROR: Wrong time parameter for timer")
   end
   local t = time
   local run_status = false
   -- use CMD to send the command to time function
   -- timer_CMD.run/stop/reset
   return function(command)
      if t == 0 then
	 if isLoop then
	    t = time
	 else
	    run_status = false
	 end
      end
      if command == nil then
	 if run_status then
	    t = t-1
	 end
      elseif command == P.run then
	 run_status = true
      elseif command == P.stop then
	 run_status = false
      elseif command == P.reset then
	 t = time
      else
	 error("ERROR: Wrong command for timer")
      end
      return t
   end
end

P.help = function()
   helpinfo =
      [==================================================[
Timer Package ver 0.0.1
Name: timer - timer lua package
Language: Lua
Author: Yunoinsky
Synopsis:
    require("timer")
Description:
    The timer package provide a simple implementation of timer and counter.
Field:
    run: constant number 1, use as the optional command for timer inner function, which will start the timer
    stop: constant number 2, use as the optional command for timer inner function, which will stop the timer
    reset: constant number 3, use as the optional command for timer inner function, which will reset the timer
Function:
    timer(time, isLoop): constructor for timer. It will return a inner function which can send the command and return the time of timer.
        time: the max/start time for timer
        isLoop: whether the timmer is recycled or not
        
    [inner function of timer]: receive the command (or nil) and return the time
        optional commands: timer.run, timer.stop, timer.reset, nil
    counter(): constructor for counter
    [inner function of counter]:receive a number/nil, accelerate and return the count number

]==================================================]
   print(helpinfo)
end   
function P.counter()
   local t = 0
   return function(acc)
      if not acc then
	 t = t+1
	 
      elseif type(acc) == "number" then
	 t = t+acc
      else
	 error("ERROR: Wrong argument type for counter")
      end
      return t
   end
end

return P
