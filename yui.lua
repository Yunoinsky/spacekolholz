require("tree")

local P = {}
if _REQUIREDNAME == nil then
   yui = P
else
   _G[_REQUIREDNAME] = p
end


P.yui_meta = {
   __index = {
      
   }
}

P.init_yui = function()
   local new_yui = {}
   
end





P.test = function()
   
end

return P
