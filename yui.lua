require("tree")

local P = {}
if _REQUIREDNAME == nil then
   yui = P
else
   _G[_REQUIREDNAME] = p
end



return P
