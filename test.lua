local json = require('cjson')
local api = require('osrm.api')
local date = require("date")

res,err = api.route({{13.428555,52.523219},{13.428545,52.523249}})
if not err then print(json.encode(res)) else print(json.encode(res)..err) end

res,err = api.route({{13.428555,52.523219},{13.428545,52.523249}},'walking')
if not err then print(json.encode(res)) else print(json.encode(res)..err) end




