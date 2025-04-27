# OSRM (Open Source Routing Machine) API Lua SDK

API: https://project-osrm.org/docs/v5.24.0/api/

## Example:

```
local api = require('osrm.api')
local json = require('cjson')

res,err = api.route({{13.428555,52.523219},{13.428545,52.523249}})

res,err = api.route({{13.428555,52.523219},{13.428545,52.523249}},'walking')

if not err then print(json.encode(res)) else print(json.encode(res)..err) end

```

## Profiles

- driving       
- walking        
- cycling 


## Services

### Nearest service

Snaps a coordinate to the street network and returns the nearest n matches.

```
nearest(coords,profile,options)

```

### Route service

Finds the fastest route between coordinates in the supplied order.

```
route(coords,profile,options)

```

### Table service

Computes the duration of the fastest route between all pairs of supplied coordinates. Returns the durations or distances or both between the coordinate pairs. Note that the distances are not the shortest distance between two coordinates, but rather the distances of the fastest routes. Duration is in seconds and distances is in meters.

```
table(coords,profile,options)

```

### Match service

Map matching matches/snaps given GPS points to the road network in the most plausible way. Please note the request might result multiple sub-traces. Large jumps in the timestamps (> 60s) or improbable transitions lead to trace splits if a complete matching could not be found. The algorithm might not be able to match all points. Outliers are removed if they can not be matched successfully.

```
match(coords,profile,options)

```

### Trip service

The trip plugin solves the Traveling Salesman Problem using a greedy heuristic (farthest-insertion algorithm) for 10 or more waypoints and uses brute force for less than 10 waypoints. The returned path does not have to be the fastest path. As TSP is NP-hard it only returns an approximation. Note that all input coordinates have to be connected for the trip service to work.

```
trip(coords,profile,options)

```

### Tile service

This service generates Mapbox Vector Tiles that can be viewed with a vector-tile capable slippy-map viewer.

```
tile(x,y,zoom,profile)

```
