paint = {}
paint.loopmax=50
paint.loops=0

minetest.register_alias("pencil", "mtpaint:pencil")
minetest.register_alias("fill", "mtpaint:fill")
minetest.register_alias("bucket", "mtpaint:fill")
minetest.register_alias("fill_column", "mtpaint:fill_column")
minetest.register_alias("fill_row", "mtpaint:fill_row")
minetest.register_alias("eraser", "mtpaint:eraser")
minetest.register_alias("gum", "mtpaint:eraser")
minetest.register_alias("picker", "mtpaint:picker")
minetest.register_alias("colorpicker", "mtpaint:picker")
minetest.register_alias("nodepicker", "mtpaint:picker")

--function

paint.has_air = function(pos)
  print("check for air")
  for i=-1,1,2 do
    local p = {x=pos.x+i, y=pos.y, z=pos.z}
    local n = minetest.env:get_node(p).name
    print(n)
    if minetest.registered_nodes[n].walkable == false then
      return true
    end
  end
  for i=-1,1,2 do
    local p = {x=pos.x, y=pos.y+i, z=pos.z}
    local n = minetest.env:get_node(p).name
    print(n)
    if minetest.registered_nodes[n].walkable == false then
      return true
    end
  end
  for i=-1,1,2 do
    local p = {x=pos.x, y=pos.y, z=pos.z+i}
    local n = minetest.env:get_node(p).name
    print(n)
    if minetest.registered_nodes[n].walkable == false then
      return true
    end
  end
  print("doesnothaveair")
  return false
end

paint.replace = function(user, position, replace, replacer, full)
  
  if not minetest.registered_nodes[replacer] then return end
  if replace == replacer then return end
  if paint.loops > 2000 then return end
  local pos = position
  if full == false then
  if paint.has_air(pos) == false then return end
  end
  paint.loops = paint.loops + 1

  local node = replacer
  
  minetest.env:set_node(pos,{name=node})
    
  for i=-1,1,2 do
    local p = {x=pos.x+i, y=pos.y, z=pos.z}
    local n = minetest.env:get_node(p).name
    if n == replace then
      minetest.env:set_node(pos,{name=node})
      paint.replace(user,p, replace, replacer, full)
    end
  end

  for i=-1,1,2 do
    local p = {x=pos.x, y=pos.y+i, z=pos.z}
    local n = minetest.env:get_node(p).name
  if n == replace then
      minetest.env:set_node(pos,{name=node})
      paint.replace(user,p, replace, replacer, full)
    end
  end
  for i=-1,1,2 do
    local p = {x=pos.x, y=pos.y, z=pos.z+i}
    local n = minetest.env:get_node(p).name
    if n == replace then
      minetest.env:set_node(pos,{name=node})
      paint.replace(user,p, replace, replacer, full)
    end
  end
end

paint.replace_column = function(user, position, replace, replacer, full)
  
  if not minetest.registered_nodes[replacer] then return end
  if replace == replacer then return end
  if paint.loops > 2000 then return end
  local pos = position
  if full == false then
   --if paint.has_air(pos) == false then return end
  end
  paint.loops = paint.loops + 1

  local node = replacer
  
  minetest.set_node(pos,{name=node})
    
  for i=-1,1,2 do
    local p = {x=pos.x, y=pos.y+i, z=pos.z}
    local n = minetest.get_node(p).name
  if n == replace then
      minetest.set_node(pos,{name=node})
      paint.replace_column(user,p, replace, replacer, full)
    end
  end
end

paint.replace_row = function(user, position, replace, replacer, full, direction)
  
  if not minetest.registered_nodes[replacer] then return end
  if replace == replacer then return end
  if paint.loops > 2000 then return end
  local pos = position
  if full == false then
   --if paint.has_air(pos) == false then return end
  end
  paint.loops = paint.loops + 1

  local node = replacer

  local dir = direction
  
  minetest.env:set_node(pos,{name=node})
    
  for i=-1,1,2 do
    local p = {x=pos.x+(i * dir.x), y=pos.y, z=pos.z+(i * dir.z)}
    local n = minetest.env:get_node(p).name
    if n == replace then
      minetest.env:set_node(pos,{name=node})
      paint.replace_row(user,p, replace, replacer, full, dir)
    end
  end
end

--tools
minetest.register_tool("mtpaint:eraser", {
  description = "Eraser",
  inventory_image = "paint_eraser.png",
  on_use = function(itemstack, user, pointed_thing)
    if pointed_thing.type == "node" then

      if (not base_functions.canPlayerPlaceAt(user, pointed_thing.under)) then return end

      minetest.env:remove_node(pointed_thing.under)
    end
  end,
})

minetest.register_tool("mtpaint:pencil", {
  description = "Pencil",
  inventory_image = "paint_pencil.png",
  on_use = function(itemstack, user, pointed_thing)
    
    if pointed_thing.type == "node" then

      if (not base_functions.canPlayerPlaceAt(user, pointed_thing.under)) then return end

      local node = user:get_inventory():get_stack("main", 1):get_name()
    
      if user:get_player_control().sneak then
    
        minetest.env:set_node(pointed_thing.under,{name=node})
    
      else
    
        minetest.env:set_node(pointed_thing.above,{name=node})
    
      end
    
    end
  end,
  on_place = function(self, user, pointed_thing)
  
    if pointed_thing.type == "node" then

      if (not base_functions.canPlayerPlaceAt(user, pointed_thing.under)) then return end

      local node = user:get_inventory():get_stack("main", 2):get_name()
  
      if user:get_player_control().sneak then
  
        minetest.env:set_node(pointed_thing.under,{name=node})
  
      else
  
        minetest.env:set_node(pointed_thing.above,{name=node})
  
      end
    end
  end,
})

minetest.register_tool("mtpaint:picker", {
  
  description = "Picker",
  
  inventory_image = "paint_picker.png",
  
  on_use = function(itemstack, user, pointed_thing)
  
    if pointed_thing.type == "node" then
  
      if (not base_functions.canPlayerPlaceAt(user, pointed_thing.under)) then return end

      local node = minetest.env:get_node(pointed_thing.under).name
  
      if node == nil or node == "ignore" then return end
  
      local oldnode = user:get_inventory():get_stack("main", 1):get_name()
  
      local stack = ItemStack(oldnode)
  
      local inv = user:get_inventory()
  
      inv:set_stack("main", 1, node)
  
      if (not inv:contains_item("main", oldnode)) then
        
        if inv:room_for_item("main", stack) then
        
          inv:add_item("main", oldnode.." 1")
        
        end
      end
    end
  end,
  on_place = function(self, user, pointed_thing)
    
    if pointed_thing.type == "node" then
  
      if (not base_functions.canPlayerPlaceAt(user, pointed_thing.under)) then return end

      local node = minetest.env:get_node(pointed_thing.under).name
  
      if node == nil or node == "ignore" then return end
  
      local oldnode = user:get_inventory():get_stack("main", 2):get_name()
  
      local stack = ItemStack(oldnode)
  
      local inv = user:get_inventory()
  
      inv:set_stack("main", 2, node)
  
      if (not inv:contains_item("main", oldnode)) then
        
        if inv:room_for_item("main", stack) then
        
          inv:add_item("main", oldnode.." 1")
        
        end
      end
    end
  end,
})

minetest.register_tool("mtpaint:fill", {
  description = "Fill",
  inventory_image = "paint_fill.png",
  on_use = function(itemstack, user, pointed_thing)
    if pointed_thing.type == "node" then
      
      if (not base_functions.canPlayerPlaceAt(user, pointed_thing.under)) then return end

      local pos = pointed_thing.under
      local replace = minetest.env:get_node(pos).name
      local replacer = user:get_inventory():get_stack("main", 1):get_name()
      paint.loops = 0
      if user:get_player_control().sneak then
        paint.replace(user, pos, replace, replacer, true)
      else
        paint.replace(user, pos, replace, replacer, false)
      end
    end
    return
  end,
  on_place = function(itemstack, user, pointed_thing)
    if pointed_thing.type == "node" then
      
      if (not base_functions.canPlayerPlaceAt(user, pointed_thing.under)) then return end

      local pos = pointed_thing.under
      local replace = minetest.env:get_node(pos).name
      local replacer = user:get_inventory():get_stack("main", 2):get_name()
      paint.loops = 0
      if user:get_player_control().sneak then
        paint.replace(user, pos, replace, replacer, true)
      else
        paint.replace(user, pos, replace, replacer, false)
      end
    end
    return
  end,
  
})

minetest.register_tool("mtpaint:fill_column", {
  description = "Fill Column",
  inventory_image = "paint_fill_column.png",
  on_use = function(itemstack, user, pointed_thing)
    if pointed_thing.type == "node" then
      
      if (not base_functions.canPlayerPlaceAt(user, pointed_thing.under)) then return end

      local pos = pointed_thing.under
      local replace = minetest.env:get_node(pos).name
      local replacer = user:get_inventory():get_stack("main", 1):get_name()
      paint.loops = 0
      if user:get_player_control().sneak then
        paint.replace_column(user, pos, replace, replacer, true)
      else
        paint.replace_column(user, pos, replace, replacer, false)
      end
    end
    return
  end,
  on_place = function(itemstack, user, pointed_thing)
    if pointed_thing.type == "node" then
      
      if (not base_functions.canPlayerPlaceAt(user, pointed_thing.under)) then return end

      local pos = pointed_thing.under
      local replace = minetest.env:get_node(pos).name
      local replacer = user:get_inventory():get_stack("main", 2):get_name()
      paint.loops = 0
      if user:get_player_control().sneak then
        paint.replace_column(user, pos, replace, replacer, true)
      else
        paint.replace_column(user, pos, replace, replacer, false)
      end
    end
    return
  end,
  
})

minetest.register_tool("mtpaint:fill_row", {
  description = "Fill Row",
  inventory_image = "paint_fill_row.png",
  on_use = function(itemstack, user, pointed_thing)
    if pointed_thing.type == "node" then

      if (not base_functions.canPlayerPlaceAt(user, pointed_thing.under)) then return end

      local pos = pointed_thing.under
      local replace = minetest.env:get_node(pos).name
      local replacer = user:get_inventory():get_stack("main", 1):get_name()

      -- Get direction
      local yaw = user:get_look_horizontal()
      local dir = {}
      if (yaw >= 3.8 and yaw < 5.5) then
     	dir = {x = 0, z = 1}
      elseif (yaw >= 5.5 or yaw < 0.8) then
      	dir = {x = 1, z = 0}
      elseif (yaw >= 0.8 and yaw < 2.4) then
      	dir = {x = 0, z = 1}
      elseif (yaw >= 2.4 and yaw < 3.8) then
      	dir = {x = 1, z = 0}
      end

      paint.loops = 0
      if user:get_player_control().sneak then
        paint.replace_row(user, pos, replace, replacer, true, dir)
      else
        paint.replace_row(user, pos, replace, replacer, false, dir)
      end
    end
    return
  end,
  on_place = function(itemstack, user, pointed_thing)
    if pointed_thing.type == "node" then

      if (not base_functions.canPlayerPlaceAt(user, pointed_thing.under)) then return end

      local pos = pointed_thing.under
      local replace = minetest.env:get_node(pos).name
      local replacer = user:get_inventory():get_stack("main", 2):get_name()

      -- Get direction
      local yaw = user:get_look_horizontal()
      local dir = {}
      if (yaw >= 3.8 and yaw < 5.5) then
     	dir = {x = 0, z = 1}
      elseif (yaw >= 5.5 or yaw < 0.8) then
      	dir = {x = 1, z = 0}
      elseif (yaw >= 0.8 and yaw < 2.4) then
      	dir = {x = 0, z = 1}
      elseif (yaw >= 2.4 and yaw < 3.8) then
      	dir = {x = 1, z = 0}
      end

      paint.loops = 0
      if user:get_player_control().sneak then
        paint.replace_row(user, pos, replace, replacer, true, dir)
      else
        paint.replace_row(user, pos, replace, replacer, false, dir)
      end
    end
    return
  end,
  
})