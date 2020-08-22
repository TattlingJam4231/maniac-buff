--[[
   Save Table to File
   Load Table from File
   v 1.0
   
   Lua 5.2 compatible
   
   Only Saves Tables, Numbers and Strings
   Insides Table References are saved
   Does not save Userdata, Metatables, Functions and indices of these
   ----------------------------------------------------
   table.save( table , filename )
   
   on failure: returns an error msg
   
   ----------------------------------------------------
   table.load( filename or stringtable )
   
   Loads a table that has been saved via the table.save function
   
   on success: returns a previously saved table
   on failure: returns as second argument an error msg
   ----------------------------------------------------
   
   Licensed under the same terms as Lua itself.
]]--
do
   -- declare local variables
   --// exportstring( string )
   --// returns a "Lua" portable version of the string
   local function exportstring( s )
      return string.format("%q", s)
   end

   --// The Save Function
   function table.save(  tbl,filename )
      local charS,charE = "   ","\n"
      local file,err = io.open( filename, "wb" )
      if err then return err end

      -- initiate variables for save procedure
      local tables,lookup = { tbl },{ [tbl] = 1 }
      file:write( "return {"..charE )

      for idx,t in ipairs( tables ) do
         file:write( "-- Table: {"..idx.."}"..charE )
         file:write( "{"..charE )
         local thandled = {}

         for i,v in ipairs( t ) do
            thandled[i] = true
            local stype = type( v )
            -- only handle value
            if stype == "table" then
               if not lookup[v] then
                  table.insert( tables, v )
                  lookup[v] = #tables
               end
               file:write( charS.."{"..lookup[v].."},"..charE )
            elseif stype == "string" then
               file:write(  charS..exportstring( v )..","..charE )
            elseif stype == "number" then
               file:write(  charS..tostring( v )..","..charE )
            end
         end

         for i,v in pairs( t ) do
            -- escape handled values
            if (not thandled[i]) then
            
               local str = ""
               local stype = type( i )
               -- handle index
               if stype == "table" then
                  if not lookup[i] then
                     table.insert( tables,i )
                     lookup[i] = #tables
                  end
                  str = charS.."[{"..lookup[i].."}]="
               elseif stype == "string" then
                  str = charS.."["..exportstring( i ).."]="
               elseif stype == "number" then
                  str = charS.."["..tostring( i ).."]="
               end
            
               if str ~= "" then
                  stype = type( v )
                  -- handle value
                  if stype == "table" then
                     if not lookup[v] then
                        table.insert( tables,v )
                        lookup[v] = #tables
                     end
                     file:write( str.."{"..lookup[v].."},"..charE )
                  elseif stype == "string" then
                     file:write( str..exportstring( v )..","..charE )
                  elseif stype == "number" then
                     file:write( str..tostring( v )..","..charE )
                  end
               end
            end
         end
         file:write( "},"..charE )
      end
      file:write( "}" )
      file:close()
   end
   
   --// The Load Function
   function table.load( sfile )
      local ftables,err = loadfile( sfile )
      if err then return _,err end
      local tables = ftables()
      for idx = 1,#tables do
         local tolinki = {}
         for i,v in pairs( tables[idx] ) do
            if type( v ) == "table" then
               tables[idx][i] = tables[v[1]]
            end
            if type( i ) == "table" and tables[i[1]] then
               table.insert( tolinki,{ i,tables[i[1]] } )
            end
         end
         -- link indices
         for _,v in ipairs( tolinki ) do
            tables[idx][v[2]],tables[idx][v[1]] =  tables[idx][v[1]],nil
         end
      end
      return tables[1]
   end
-- close do
end

-- ChillCode



function PlayerManager:_update_damage_dealt(t, dt)
	local local_peer_id = managers.network:session() and managers.network:session():local_peer():id()

	if not local_peer_id or not self:has_category_upgrade("player", "cocaine_stacking") then
		return
	end

	self._damage_dealt_to_cops_t = self._damage_dealt_to_cops_t or t + (tweak_data.upgrades.cocaine_stacks_tick_t or 1)
	
	self._damage_dealt_to_cops_decay_trigger_t = self._damage_dealt_to_cops_decay_trigger_t or t + (tweak_data.upgrades.cocaine_stacks_decay_trigger_t or 6)
	
	local cocaine_stack = self:get_synced_cocaine_stacks(local_peer_id)
	local amount = cocaine_stack and cocaine_stack.amount or 0
	local new_amount = amount
	
	self._damage_dealt_to_cops_prev = self._damage_dealt_to_cops_prev or 0
	if self._damage_dealt_to_cops_prev < tweak_data.upgrades.max_cocaine_stacks_per_tick/10 then
		local new_stacks = (math.min((self._damage_dealt_to_cops or 0), tweak_data.upgrades.max_cocaine_stacks_per_tick/10) - self._damage_dealt_to_cops_prev) * (tweak_data.gui.stats_present_multiplier or 10) * self:upgrade_value("player", "cocaine_stacking", 0)
		new_amount = new_amount + math.min(new_stacks, tweak_data.upgrades.max_cocaine_stacks_per_tick or 20)
		self._damage_dealt_to_cops_prev = math.min((self._damage_dealt_to_cops or 0), 24)
	end
	
	if self._damage_dealt_to_cops_t <= t then
		self._damage_dealt_to_cops_t = t + (tweak_data.upgrades.cocaine_stacks_tick_t or 1)
		self._damage_dealt_to_cops = 0
		self._damage_dealt_to_cops_prev = 0
		self._damage_dealt_by_cops_prev = 0
	end
	
	if self._damage_dealt_to_cops_decay_trigger_t <= t then
		self._damage_dealt_to_cops_decay_t = self._damage_dealt_to_cops_decay_t or t + (tweak_data.upgrades.cocaine_stacks_decay_t or 5)
		
		if self._damage_dealt_to_cops_decay_t <= t then
			self._damage_dealt_to_cops_decay_t = t + (tweak_data.upgrades.cocaine_stacks_decay_t or 5)
			local decay = amount * (tweak_data.upgrades.cocaine_stacks_decay_percentage_per_tick or 0)
			decay = decay + tweak_data.upgrades.cocaine_stacks_decay_amount_per_tick or 20
			new_amount = new_amount - decay
		end
	end

	new_amount = math.clamp(math.floor(new_amount), 0, tweak_data.upgrades.max_total_cocaine_stacks or 2047)
	if new_amount > tweak_data.upgrades.max_total_cocaine_stacks then
		self._damage_dealt_to_cops = self._damage_dealt_to_cops - (new_amount - tweak_data.upgrades.max_total_cocaine_stacks)
		self._damage_dealt_to_cops_prev = self._damage_dealt_to_cops_prev - (new_amount - tweak_data.upgrades.max_total_cocaine_stacks)
	end
	
	self.cocaine_stack_amount_prev = new_amount
	
	if new_amount ~= amount then
		self:update_synced_cocaine_stacks_to_peers(new_amount, self:upgrade_value("player", "sync_cocaine_upgrade_level", 1), self:upgrade_level("player", "cocaine_stack_absorption_multiplier", 0))
	end
end


function PlayerManager:_check_damage_to_cops(t, unit, damage_info)
	local player_unit = self:player_unit()

	if alive(player_unit) and not player_unit:character_damage():need_revive() and player_unit:character_damage():dead() then
		-- Nothing
	end

	if not alive(unit) or not unit:base() or not damage_info then
		return
	end

	if damage_info.is_fire_dot_damage then
		return
	end

	if CopDamage.is_civilian(unit:base()._tweak_table) then
		return
	end
	-- and not damage_info.attacker_unit:base().sentry_gun 
	if damage_info.variant ~= "fire" and damage_info.variant ~= "poison" and not damage_info.attacker_unit:base().sentry_gun then
		self._damage_dealt_to_cops_decay_trigger_t = t + (tweak_data.upgrades.cocaine_stacks_decay_trigger_t or 6)
		self._damage_dealt_to_cops_decay_t = t + (tweak_data.upgrades.cocaine_stacks_decay_t or 5)
	end
	
	-- local mytable = {damage_info.attacker_unit:base()}
	-- table.save(mytable,"C:\\Users\\USER\\Desktop\\payday debug\\debug.txt")

	self._damage_dealt_to_cops = self._damage_dealt_to_cops or 0
	self._damage_dealt_to_cops = self._damage_dealt_to_cops + (damage_info.damage or 0)
end


function PlayerManager:cocaine_stack_damage_reduction(damage)
	local local_peer_id = managers.network:session() and managers.network:session():local_peer():id()

	if not local_peer_id or not self:has_category_upgrade("player", "cocaine_stacking") then
		return damage
	end
	
	local dmg = damage
	local cocaine_stack = self:get_synced_cocaine_stacks(local_peer_id)
	local amount = cocaine_stack and cocaine_stack.amount or 0
	self._damage_dealt_by_cops_prev = self._damage_dealt_by_cops_prev or 0
	local amount_prev = amount
	
	local damage_reduction = 1
	local stack_damage = self:upgrade_value_by_level("player", "cocaine_stacks_damaged_1", 1, 0)
	if self:has_category_upgrade("player", "cocaine_stacks_damaged_2") then
		stack_damage = self:upgrade_value_by_level("player", "cocaine_stacks_damaged_2", 1, 0)
	end
	if self:has_category_upgrade("player", "cocaine_stacks_damage_reduction_2") then
		damage_reduction = self:upgrade_value_by_level("player", "cocaine_stacks_damage_reduction_2", 1, 0)
		stack_damage = self:upgrade_value_by_level("player", "cocaine_stacks_damaged_2", 1, 0)
	elseif self:has_category_upgrade("player", "cocaine_stacks_damage_reduction_1") then
		damage_reduction = self:upgrade_value("player", "cocaine_stacks_damage_reduction_1", 0)
	end
	
	if amount > 0 then
		if self._damage_dealt_by_cops_prev < tweak_data.upgrades.max_cocaine_damage_per_tick then
			if self._damage_dealt_by_cops_prev + stack_damage > tweak_data.upgrades.max_cocaine_damage_per_tick then
				stack_damage = tweak_data.upgrades.max_cocaine_damage_per_tick - self._damage_dealt_by_cops_prev
			end
			amount = amount - stack_damage
			self._damage_dealt_by_cops_prev = self._damage_dealt_by_cops_prev + stack_damage
		end
		
		dmg = dmg * damage_reduction
		
		self:update_synced_cocaine_stacks_to_peers(amount, self:upgrade_value("player", "sync_cocaine_upgrade_level", 1), self:upgrade_level("player", "cocaine_stack_absorption_multiplier", 0))
	end
	return dmg
end