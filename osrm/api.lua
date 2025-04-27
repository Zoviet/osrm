local json = require('cjson')
local cURL = require("cURL")
local date = require("date")
local log = require('utils.log')
local config = require('config.osrm')

local _M = {}
_M.result = nil
_M.base = config.url
_M.format = config.format
log.outfile = 'logs/osrm_'..os.date('%Y-%m-%d')..'.log' 
log.level = 'trace'	
_M.defaults = {
	['generate_hints'] = true,
	['snapping'] = 'default',
	['skip_waypoints'] = false
}
_M.profile = 'driving' -- location /route/v1/driving       location /route/v1/walking        location /route/v1/cycling 

function coordinates(coords)
	if coords[1] then
		if type(coords[1]) == 'number' then return table.concat(coords,',') end
		local out = {}
		for i,c in pairs(coords) do table.insert(out,table.concat(c,',')) end
		return table.concat(out,';')
	end	
	return nil
end

function query(data)
	if not data then return '' end
	local str = '?'
	for k,v in pairs(data) do 
		if str == '?' then str = str..k..'='..tostring(v)
		else str = str..'&'..k..'='..tostring(v) end
	end
	return str
end

function get_result(str,url)
	local result, err = pcall(json.decode,str)
	if result then
		_M.result = json.decode(str)
	else
		log.error(url..':'..err)
		return nil,	err
	end	
	return _M.result
end

function get(service,coords,profile,options)
	local str = ''
	local url = ''
	local res
	profile = profile or _M.profile 
	if service == 'tile' then
		url =  _M.base..service..'/'..config.version..'/'..profile..'/tile('..table.concat(coords,',')..').mvt'
	else
		url =  _M.base..service..'/'..config.version..'/'..profile..'/'..coordinates(coords)..query(options)
	end
	local headers = {
		'Content-type: application/json',
		'Accept: application/json'	
	}
	local c = cURL.easy{		
		url = url,	
		httpheader  = headers,	
		writefunction = function(st)	
			str = str..st
		end
	}
	local ok, err = c:perform()	
	local code = c:getinfo_response_code()
	c:close()
	if not ok then return nil, err end
	if code ~= 200 then return {['code']=code,['url']=url},str end
	if _M.format == 'json' then
		res,err = get_result(str,url)
	else
		res = str
	end
	if not res then return nil,err end
	return res
end

function _M.route(coords,profile,options_route)
	if not options_route then 
		options_route = _M.defaults 
		options_route['alternatives'] = false
		options_route['steps'] = false
		options_route['annotations'] = false
		options_route['geometries'] = 'polyline'
		options_route['overview'] = 'simplified'
		options_route['continue_straight'] = 'default'
	end
	return get('route',coords,profile,options_route)
end

function _M.nearest(coords,profile,options_nearest)
	if not options_nearest then 
		options_nearest = _M.defaults 
		oprions['number'] = 1
	end
	return get('nearest',coords,profile,options_nearest)
end

function _M.table(coords,profile,options_table)
	if not options_table then 
		options_table = _M.defaults 
		options_table['annotations'] = 'duration'
		options_table['fallback_coordinate'] = 'input'
	end
	return get('table',coords,profile,options_table)
end

function _M.match(coords,profile,options_match)
	if not options_match then 
		options_match = _M.defaults
		options_match['steps'] = false
		options_match['geometries'] = 'polyline'
		options_match['annotations'] = false
		options_match['overview'] = 'simplified'
		options_match['gaps'] = 'split'
		options_match['tidy'] = false
	end
	return get('match',coords,profile,options_match)
end

function _M.trip(coords,profile,options_trip)
	if not options_trip then 
		options_trip = _M.defaults
		options_trip['roundtrip'] = true
		options_trip['source'] = 'any'
		options_trip['destination'] = 'any'
		options_trip['steps'] = false
		options_trip['annotations'] = false
		options_trip['geometries'] = 'polyline'
		options_trip['overview'] = 'simplified'
	end
	return get('trip',coords,profile,options_trip)
end

function _M.tile(x,y,zoom,profile)
	return get('tile',profile,{x,y,zoom})
end

return _M
