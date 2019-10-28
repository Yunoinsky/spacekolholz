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
	 self.t_map_node(self, func, ...)
      end,

      t_map_r = function(self, func, ...)
	 self.t_map_node_r(self, func, ...)
      end,

      t_map_node = function(list_node_ptr, func, ...)
	 func(list_node_ptr[0][0], ...)
	 t_node_ptr[1]:map(P.scene_tree_meta.t_map_node, func, ...)
      end,

      t_map_node_r = function(list_node_ptr, func, ...)
	 func(list_node_ptr[0][0], ...)
	 t_node_ptr[1]:map_r(P.scene_tree_meta.t_map_node, func, ...)
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
	    
	 elseif type(self.root)=="table" then
	    error("ERROR: Miss the father node")
	 else
	    self.root = component
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
	    result = self.root
	    self.root = nil
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



return P
