--[[


]]--


require("linklist")

local P = {}
if _REQUIREDNAME == nil then
   tree = P
else
   _G[_REQUIREDNAME] = p
end




P.scene_tree_node_meta={
   __index={
      t_component = function(self)
	 return self[0]
      end,
      subnodes = function(self)
	 return self[1]
      end,
      father = function(self)
	 return self[2]
      end,
      type = function(self)
	 return self[3]
      end
   }
}

P.scene_tree_meta = {
   __index = {
      root = function(self)
	 return self[0]
      end,

      set_root = function(self, root)
	 self[0] = root
      end,

      type = function(self)
	 return self[1]
      end,

      t_map = function(self, func, ...)
	 self.t_map_node(self[0], func, ...)
      end,

      t_map_r = function(self, func, ...)
	 self.t_map_node_r(self[0], func, ...)
      end,

      t_map_node = function(map_node_ptr, func, ...)
	 func(map_node_ptr, ...)
	 local tempfun = function(linklist_node, ...)
	    P.scene_tree_meta.__index.t_map_node(linklist_node[0], func, ...)
	    return nil
	 end
	 map_node_ptr[1]:map(tempfun, ...)
	 return nil
      end,

      t_map_node_r = function(map_node_ptr, func, ...)
	 func(map_node_ptr, ...)
	 local tempfun = function(linklist_node, ...)
	    P.scene_tree_meta.__index.t_map_node(linklist_node[0], func, ...)
	    return nil
	 end
	 map_node_ptr[1]:map_r(tempfun, ...)
	 return nil
      end,


      t_insert = function(self, component, fathernode, name)
	 local comptype = nil
	 if type(component) == "table" then
	    comptype = component[3]
	 end
	 if comptype == "linklist_node_meta" then
	    if component[0][3] == "scene_tree_node" then
	 
	       component = component[0]
	       component[2] = fathernode
	    else
	       error("ERROR: The listnode is not unpacked")
	    end
	 elseif comptype == "scene_tree_node" then
	    component[2] = fathernode
	 else
	    component = {
	       [0] = component,
	       [1] = linklist.linklist(),
	       [2] = fathernode,
	       [3] = "scene_tree_node"
	    }
	 end
	 setmetatable(component, P.scene_tree_node_meta)

	 if fathernode then
	    fathernode[1]:insert(component,name)
	    
	 elseif type(self[0])=="table" then
	    error("ERROR: Miss the father node")
	 else
	    self[0] = component
	 end

	 return component
      end,
      t_pop = function(self, fathernode, node)
	 local result
	 if fathernode then
	    result = fathernode[1]:pop(node)
	 elseif node then
	    error("ERROR: Miss the father node")
	 else
	    result = self[0]
	    self[0] = nil
	 end
	 return result
      end,
      t_get_node = function(self, fathernode, nodename)
	 return fathernode[1]:get_node(nodename)
      end
      
   }
}
P.scene_tree = function()
   local newtree = {
      [0] = nil,
      [1] = "scene_tree"
   }
   setmetatable(newtree, P.scene_tree_meta)
   return newtree
end

P.test = function()
   _DEBUG = true
   local a = P.scene_tree()
   local b = a:t_insert(5)
   
   local c = a:t_insert(15, b, "hehe")
   a:t_insert(55, c,"heihei")
   a:t_insert(33, b, "lala")
   a:t_map(function(s) print(s[0]) end)
   _DEBUG = false
end

if _TEST then
   P.test()
end

return P
