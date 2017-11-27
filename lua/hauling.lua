--luacheck: in=
function hauling_get_routes()
	local ret = {}

	for i,route in ipairs(df.global.ui.hauling.routes) do
		local name = routename(route)

		table.insert(ret, { name, route.id })
	end

	return ret
end

--luacheck: in=number
function hauling_route_info(id)
	local route = df.hauling_route.find(id)

	if not route then
		error('no route '..tostring(id))
	end

	local stops = {}
	for i,v in ipairs(route.stops) do
		--todo: df.global.ui.hauling.view_bad
		table.insert(stops, { stopname(v), v.id })
	end

	return { routename(route), route.id, stops }
end

--luacheck: in=number
function hauling_route_delete(id)
	execute_with_hauling_menu(function(ws)
		for i,v in ipairs(df.global.ui.hauling.view_routes) do
			if v.id == id then
				df.global.ui.hauling.cursor_top = i
				gui.simulateInput(ws, K'D_HAULING_REMOVE')
				return true
			end
		end
	end)	
end

--luacheck: in=number,number
function hauling_route_delete_stop(routeid, stopid)
	return execute_with_hauling_menu(function(ws)
		for i,v in ipairs(df.global.ui.hauling.view_stops) do
			if v.id == stopid and df.global.ui.hauling.view_routes[i].id == routeid then
				df.global.ui.hauling.cursor_top = i
				gui.simulateInput(ws, K'D_HAULING_REMOVE')
				return true
			end
		end
	end)
end

--luacheck: in=number
function hauling_vehicle_get_choices(routeid)
	return execute_with_hauling_menu(function(ws)
		for i,v in ipairs(df.global.ui.hauling.view_routes) do
			if v.id == routeid then
				df.global.ui.hauling.cursor_top = i
				gui.simulateInput(ws, K'D_HAULING_VEHICLE')
				if not df.global.ui.hauling.in_assign_vehicle then
					error('could not switch to vehicle assign mode')
				end
				
				local ret = {}
				for i,vehicle in ipairs(df.global.ui.hauling.vehicles) do
					if not vehicle then
						table.insert(ret, { 'None', -1 })
					else
						local item = df.item.find(vehicle.item_id)
						local itemname = item and itemname(item, 1, true)

						table.insert(ret, { itemname, vehicle.id, item.id })
					end
				end

				return ret
			end

			error('no route with id '..tostring(routeid))
		end
	end)
end

--luacheck: in=number,number
function hauling_vehicle_assign(routeid, vehicleid)
	return execute_with_hauling_menu(function(ws)
		for i,v in ipairs(df.global.ui.hauling.view_routes) do
			if v.id == routeid then
				df.global.ui.hauling.cursor_top = i
				gui.simulateInput(ws, K'D_HAULING_VEHICLE')
				if not df.global.ui.hauling.in_assign_vehicle then
					error('could not switch to vehicle assign mode')
				end
				
				local ret = {}
				for j,vehicle in ipairs(df.global.ui.hauling.vehicles) do
					if (not vehicle and vehicleid == -1) or (vehicle and vehicle.id == vehicleid) then
						df.global.ui.hauling.cursor_vehicle = j
						gui.simulateInput(ws, K'SELECT')
						return true
					end
				end

				error('no vehicle with id '..tostring(vehicleid))
			end
		end

		error('no route with id '..tostring(routeid))
	end)
end

--luacheck: in=
function hauling_route_new()
	return execute_with_hauling_menu(function(ws)
		gui.simulateInput(ws, K'D_HAULING_NEW_ROUTE')
	end)
end

--luacheck: in=number,string
function hauling_route_set_name(id,name)
	local route = df.hauling_route.find(id)

	if not route then
		error('no route '..tostring(id))
	end

	route.name = name
end

--luacheck: in=number
function hauling_route_start_edit(id)
	for i,v in ipairs(df.global.ui.hauling.view_routes) do
		if v.id == id then
			return execute_with_hauling_menu(function(ws)
				df.global.ui.hauling.cursor_top = i
				return true
			end, true)
		end
	end
	
	error('no route '..tostring(id))
end

--luacheck: in=
function hauling_route_end_edit()
	reset_main()
end

-- print(pcall(function()return json:encode(hauling_get_routes())end))
--print(pcall(function()return json:encode(hauling_route_info(2))end))
--print(pcall(function()return json:encode(hauling_vehicle_get_choices(2))end))
--print(pcall(function()return json:encode(hauling_vehicle_assign(2,48))end))
--print(pcall(function()return json:encode(hauling_route_new())end))
--print(pcall(function()return json:encode(hauling_route_set_name(130,''))end))
-- print(pcall(function()return json:encode(hauling_route_start_edit(2,''))end))
