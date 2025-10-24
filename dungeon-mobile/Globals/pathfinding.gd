extends Node

var _graph = {}
var _obstacles = []
var _doors = []

func create_graph(locations: Array[Vector2i]):
	for location1 in locations:
		_graph[location1] = []
		for location2 in locations:
			var distance = heuristic(location1, location2)
			
			if distance <= 1.5 and distance > 0:
				if not location2 in _graph[location1]:
					_graph[location1].append(location2)

func update_obstacles(obstacles):
	_obstacles = obstacles

func update_doors(doors):
	_doors = doors

func filter_locations(locations: Array[Vector2i]):
	var valid_locations = []
	for location in locations:
		if _graph.has(location) && !_obstacles.has(location):
			valid_locations.append(location)
	
	return valid_locations

# A* pathfinding algorithm to find a path from start to end in the graph
# Returns an array of Vector2i positions representing the path, or an empty array if no path is found
func find_path(start: Vector2i, end: Vector2i) -> Array[Vector2i]:
	if not _graph.has(start) or not _graph.has(end):
		return []
	
	if start == end:
		return [end]
	
	# Priority queue using a dictionary where key is the node and value is its f_score
	var open_set = {}
	open_set[start] = 0  # f_score
	
	# For node n, came_from[n] is the node immediately preceding it on the cheapest path from start to n
	var came_from = {}
	
	# For node n, g_score[n] is the cost of the cheapest path from start to n currently known
	var g_score = {}
	for node in _graph:
		if !_obstacles.has(node):
			g_score[node] = INF
	g_score[start] = 0
	
	# For node n, f_score[n] = g_score[n] + h(n). f_score[n] represents our current best guess as to
	# how short a path from start to finish can be if it goes through n.
	var f_score = {}
	for node in _graph:
		if !_obstacles.has(node):
			f_score[node] = INF
	f_score[start] = heuristic(start, end)
	
	while open_set.size() > 0:
		# Get the node in open_set having the lowest f_score[] value
		var current = null
		var current_score = INF
		for node in open_set:
			if f_score[node] < current_score:
				current = node
				current_score = f_score[node]
		
		if current == end:
			var path = reconstruct_path(came_from, current)
			path.erase(start)
			return path
		
		open_set.erase(current)
		
		for neighbor in _graph[current]:
			if _obstacles.has(neighbor):
				continue
			
			# d(current,neighbor) is the weight of the edge from current to neighbor
			# For a grid, we'll use 1 as the distance between adjacent nodes
			var tentative_g_score = g_score[current] + 1
			
			if tentative_g_score < g_score[neighbor]:
				# This path to neighbor is better than any previous one
				came_from[neighbor] = current
				g_score[neighbor] = tentative_g_score
				f_score[neighbor] = g_score[neighbor] + heuristic(neighbor, end)
				if not open_set.has(neighbor):
					open_set[neighbor] = f_score[neighbor]
			
	# Open set is empty but goal was never reached
	return []

# Heuristic function for A* - using Manhattan distance
func heuristic(a: Vector2i, b: Vector2i) -> float:
	return (abs(a.x - b.x) + abs(a.y - b.y) + abs(a.x + a.y - (b.x + b.y))) / 2

# Reconstruct the path from start to end using the came_from dictionary
func reconstruct_path(came_from: Dictionary, current: Vector2i) -> Array[Vector2i]:
	var total_path : Array[Vector2i] = [current]
	while came_from.has(current):
		current = came_from[current]
		total_path.append(current)
	total_path.reverse()
	return total_path

# Finds all reachable locations within a specific distance from the start location
# Returns a dictionary where keys are locations and values are their distances from start
func find_locations(start: Vector2i, max_distance: int) -> Dictionary:
	var result = {}
	if not _graph.has(start) or max_distance < 0:
		return result
	
	var queue = []
	var visited = {}
	queue.append({"pos": start, "distance": 0})
	visited[start] = true
	
	while queue.size() > 0:
		var current = queue.pop_front()
		var current_pos = current["pos"]
		var current_distance = current["distance"]
		
		# Add to results if within distance
		if current_distance <= max_distance and current_distance > 0:
			result[current_pos] = current_distance
		
		# Stop if we've reached max distance
		if current_distance >= max_distance:
			continue
		
		# Check all neighbors
		for neighbor in _graph.get(current_pos, []):
			if !_obstacles.has(neighbor):
				if not visited.has(neighbor):
					visited[neighbor] = true
					queue.append({"pos": neighbor, "distance": current_distance + 1})
	
	return result

func neighbours(location: Vector2i) -> Array:
	var all_neighbours = []
	for neighbor in _graph.get(location, []):
		all_neighbours.append(neighbor)
	
	return all_neighbours
