local json = require('cjson')
local api = require('osrm.api')
local date = require("date")

res,err = api.route({{48.395994,54.324645},{48.398233,54.343602}})
if not err then print(res.routes[1].distance) else print(json.encode(res)..err) end

res,err = api.route({{13.428555,52.523219},{13.428545,52.523249}},'walking')
if not err then print(json.encode(res)) else print(json.encode(res)..err) end

res,err = api.table({{50.1169,53.1912},{50.1661,53.2172},{50.0839,53.1881},{50.128,53.1985},{50.1057,53.1846}})
if not err then print(json.encode(res)) else print(json.encode(res)..err) end

res,err = api.table({{50.1169,53.1912},{50.1661,53.2172},{50.0839,53.1881},{50.128,53.1985},{50.1057,53.1846}},'driving',{['sources']=0,['destinations']=4})
if not err then print(json.encode(res)) else print(json.encode(res)..err) end

