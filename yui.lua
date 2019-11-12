require("tree")

local P = {}
if _REQUIREDNAME == nil then
   yui = P
else
   _G[_REQUIREDNAME] = p
end


P.yui_meta = {
   __index = {
      update = function(self, ...)
	 self[1]:t_map_r(function(map_node_ptr, ...) map_node_ptr[0]:update(...) end, ...)
      end,
      draw = function(self)
	 self[1]:t_map_r(function(map_node_ptr, ...) map_node_ptr[0]:draw(...) end, ...)
      end,
      
      
   }
}

P.frame = function()
   
end

P.yui = function()
   local new_yui = {
      [0] = "New_yui" -- yui name
      [1] = tree.scene_tree()
      [2] = "yui"
   }
   setmetatable(new_yui, P.yui_meta)
   return new_yui
end





P.test = function()
   
end

return P
