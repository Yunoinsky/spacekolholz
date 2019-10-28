require("timer")

local P = {}
if _REQUIREDNAME == nil then
   linklist = P
else
   _G[_REQUIREDNAME] = p
end

P.linklist_node_meta = {
   __index = {
      component = function(self)
	 return self[0]
      end,
      prev = function(self)
	 return self[1]
      end,
      next = function(self)
	 return self[2]
      end,
      set_component = function(self, component)
	 self[0] = component
      end,
      set_prev = function(self, prev)
	 self[1] = prev
      end,
      set_next = function(self, next)
	 self[2] = next
      end,
      type = function(self)
	 return self[3]
      end
   }
}
P.linklist_meta = {
   __index = {
      get_node = function(self, node)
	 local target_node
	 local node_type = type(node)
	 if node_type == "string" then
	    target_node = self[2][node]
	    if not target_node then
	       error("ERROR: Don't have such node")
	    end
	 elseif node_type == "table" then
	    if node[0] then
	       target_node = node
	    else
	       local nodename = node.id_name
	       if nodename then
		  target_node = self[2][nodename]
	       else
		  error("ERROR: The table is not a node or node component")
	       end
	    end
	 else
	    error("ERROR: Wrong input type")
	 end
	 return target_node
      end,
      
      get_node_name = function(self, node)
	 local nodename
	 local node_type = type(node)
	 if node_type == "string" then
	    if self[2][node] then
	       nodename = node
	    else
	       error("ERROR: Don't have such node")
	    end
	 elseif node_type == "table" then
	    nodename = node.id_name
	    if not nodename then
	       nodename = node[0].id_name
	    end
	    if not nodename then
	       error("ERROR: The table is not a node or node component")
	    end
	 else
	    error("ERROR: Wrong input type")
	 end
	 return nodename
      end,
            
      -- insert function
      -- self: the linklist to insert the node
      -- name: string, the name of node for indexing
      -- prenode: string or table or nil, where to insert the new node, if prenode_name is nil, the new node will add to the head of linklist
      -- node {
      --     [0] node_component,
      --     [1] prev_node,
      --     [2] next_node,
      --     [3] "linklist_node"
      -- }
      insert = function(self, component, name, prenode_name)
	 local newnode
	 if name then
	    newnode = {[3] = "linklist_node"}
	    setmetatable(newnode, P.linklist_node_meta)
	    if self[2][name] then
	       print("WARNING: Already has this node")
	       return self[2][name]
	    end
	    if type(component) ~= "table" then
	       component={value = component}
	    end
	    if component[3] == "linklist_node" then
	       component = component[0]
	    end
	    newnode[0] = component
	    newnode[0].id_name = name
	    if prenode_name == nil then
	       newnode[1] = nil
	       newnode[2] = self[0]
	       if self[0] then
		  self[0][1] = newnode
	       else
		  self[1] = newnode
	       end
	       self[0] = newnode
	    else
	       local prenode = self.get_node(self, prenode_name)
	       newnode[2] = prenode[2]
	       newnode[1] = prenode
	       if prenode[2] then
		  prenode[2][1] = newnode
	       else
		  self[1] = newnode
	       end
	       prenode[2] = newnode
	    end
	    self[2][name] = newnode

	 else
	    newnode = self.insert_s(self, component, prenode_name)
	 end
	 
	 return newnode
      end,

      
      insert_r = function(self, component, name)
	 return self.insert(self, component, name, self[1])
      end,

      -- simple insert, don't need explicit name
      insert_s = function(self, component, prenode_name)
	 local n
	 if type(component)== "table" and component[3] == "linklist_node" then
	    n = component[0].id_name
	 end
	 if not n then 
	    repeat
	       n = tostring(self[3]())
	    until not self[2][n]
	 end
	 return self.insert(self, component, n, prenode_name)
      end,

      insert_rs = function(self, component)
	 return self.insert_s(self, component, self[1])
      end,
            
      pop = function(self, node)
	 local tar_node_name
	 local tar_node
	 if self.is_empty(self) then
	    if _G["_DEBUG"] then
	       print("The linklist is empty")
	    end
	    return nil
	 end
	 if node then
	    tar_node_name = self.get_node_name(self, node)
	    tar_node = self[2][tar_node_name]
	 else
	    tar_node = self[0]
	    tar_node_name = tar_node[0].id_name
	 end
	 if tar_node[1] then
	    tar_node[1][2] = tar_node[2]
	 else
	    self[0] = tar_node[2]
	 end
	 if tar_node[2] then
	    tar_node[2][1] = tar_node[1]
	 else
	    self[1] = tar_node[1]
	 end
	 self[2][tar_node_name] = nil
	 return tar_node
      end,


      pop_r = function(self)
	 return self.pop(self, self[1])
      end,


	 
      is_empty = function(self)
	 return self[0] == nil
      end,

      map = function(self, func, ...)
	 local iter = self[0]
	 local results = {}
	 while iter do
	    table.insert(results, func(iter[0], ...))
	    iter = iter[2]
	 end
	 return results
      end,

      map_r = function(self, func, ...)
	 local iter = self[1]
	 local results = {}
	 while iter do
	    table.insert(results, func(iter[0], ...))
	    iter =  iter[1]
	 end
	 return results
      end,

      print_all_values = function(self)
	 local templambda = function(s)
	    local v=s.value
	    if not v then
	       print("Warning: value is nil")
	    end
	    if _G["_DEBUG"] then
	       print(v)
	    end
	    return v
	 end
	 return self.map(self, templambda)
      end,

      move_to = function(self, src_node, tar_pre_node)
	 local from = self.get_node(self, src_node)

	 if from[2] then
	    from[2][1] = from[1]
	 else
	    self[1] = from[1]
	 end
	 if from[1] then
	    from[1][2] = from[2]
	 else
	    self[0] = from[2]
	 end

	 if not tar_pre_node then
	    self[0][1] = from
	    from[2] = self[0]
	    from[1] = nil
	    self[0] = from
	 else
	    local to = self.get_node(self, tar_pre_node)
	    if not to[2] then
	       self[1] = from
	    end
	    from[2] = to[2]
	    from[1] = to
	    to[2] = from
	 end
	 return from
      end,

      clear = function(self)
	 self[0] = nil
	 self[1] = nil
	 self[2] = {}
	 self[3] = timer.counter()
      end,
      head = function(self)
	 return self[0]
      end,
      set_head = function(self, head)
	 self[0] = head
      end,
      tail = function(self)
	 return self[1]
      end,
      set_tail = function(self, tail)
	 self[1] = tail
      end,
      list = function(self)
	 return self[2]
      end,
      count = function(self)
	 return self[3]
      end,
      type = function(self)
	 return self[4]
      end
		     
   }
}

-- 0: head
-- 1: tail
-- 2: list
-- 3: count
P.linklist = function()
   local newlinklist = {
      [0] = nil, -- head
      [1] = nil, -- tail
      [2] = {}, -- list
      [3] = timer.counter(), -- count
      [4] = "linklist"
   }
   setmetatable(newlinklist, P.linklist_meta)
   return newlinklist   
end


P.test = function()
   local a = P.linklist()
   a:insert(5)
   a:insert(6)
   
   a:insert(88,"haha","1")
   print(a:pop():component().value)
   a:insert(19)
   a:move_to("1")
   a:print_all_values()
end

if _TEST then
   P.test()
end

return P
