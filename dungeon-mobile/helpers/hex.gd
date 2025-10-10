@tool
extends Node

# Using Vector2i for 2D coordinates (Axial and Offset)
# Using Vector3i for 3D coordinates (Cube)

# Direction vectors for cube coordinates
const CUBE_DIRECTIONS = [
	Vector3i(+1, 0, -1), Vector3i(+1, -1, 0), Vector3i(0, -1, +1),
	Vector3i(-1, 0, +1), Vector3i(-1, +1, 0), Vector3i(0, +1, -1)
]

# Diagonal vectors for cube coordinates
const CUBE_DIAGONALS = [
	Vector3i(+2, -1, -1), Vector3i(+1, -2, +1), Vector3i(-1, -1, +2),
	Vector3i(-2, +1, +1), Vector3i(-1, +2, -1), Vector3i(+1, +1, -2)
]

func position_to_axial(location):
	var x = 0
	var y = round(location.z / 1.495512)
	if int(y) & 1 == 0:
		x = round(location.x / 1.730272)
	else:
		x = round((location.x - 0.865136) / 1.730272)
	
	return offset_to_axial(Vector2i(x, y))

func axial_to_position(axial):
	var offset = axial_to_offset(axial)
	var x = 0
	var y = offset.y * 1.495512
	if int(offset.y) & 1 == 0:
		x = offset.x * 1.730272
	else:
		x = offset.x * 1.730272 + 0.865136
	
	return Vector3(x, 0, y)

# Convert offset to axial coordinates (odd-r offset)
func offset_to_axial(offset: Vector2i) -> Vector2i:
	@warning_ignore("integer_division")
	var q = offset.x - (offset.y - (offset.y & 1)) / 2
	return Vector2i(q, offset.y)

# Convert axial to offset coordinates (odd-r offset)
func axial_to_offset(axial: Vector2i) -> Vector2i:
	@warning_ignore("integer_division")
	var col = axial.x + (axial.y - (axial.y & 1)) / 2
	return Vector2i(col, axial.y)

# Convert axial to cube coordinates
func axial_to_cube(axial: Vector2i) -> Vector3i:
	return Vector3i(axial.x, axial.y, -axial.x - axial.y)

# Convert cube to axial coordinates
func cube_to_axial(cube: Vector3i) -> Vector2i:
	return Vector2i(cube.x, cube.y)

# Convert axial coordinates to a string key
# axial: The axial coordinates to convert
# Returns: A string in the format "q,r"
func axial_to_key(axial: Vector2i) -> String:
	return "%d,%d" % [axial.x, axial.y]

# Convert an axial key string back to axial coordinates
# key: The string key in format "q,r"
# Returns: A Vector2i with the axial coordinates
func key_to_axial(key: String) -> Vector2i:
	var parts = key.split(",")
	if parts.size() != 2:
		push_error("Invalid axial key format: " + key)
		return Vector2i.ZERO
	return Vector2i(int(parts[0]), int(parts[1]))

# Round cube coordinates to the nearest hex
func cube_round(cube: Vector3) -> Vector3i:
	var q = int(round(cube.x))
	var r = int(round(cube.y))
	var s = int(round(cube.z))
	
	var q_diff = abs(q - cube.x)
	var r_diff = abs(r - cube.y)
	var s_diff = abs(s - cube.z)
	
	if q_diff > r_diff and q_diff > s_diff:
		q = -r - s
	elif r_diff > s_diff:
		r = -q - s
	else:
		s = -q - r
				
	return Vector3i(q, r, s)

# Linear interpolation between two values
func lerp(a: float, b: float, t: float) -> float:
	return a + (b - a) * t

# Linear interpolation between two cube coordinates
func cube_lerp(a: Vector3, b: Vector3, t: float) -> Vector3:
	return Vector3(
		lerp(a.x, b.x, t),
		lerp(a.y, b.y, t),
		lerp(a.z, b.z, t)
	)

# Calculate distance between two cube coordinates
func cube_distance(a: Vector3, b: Vector3) -> int:
	return int((abs(a.x - b.x) + abs(a.y - b.y) + abs(a.z - b.z)) / 2)

# Get all neighbors of a cube coordinate
func cube_neighbors(cube: Vector3) -> Array[Vector3]:
	return CUBE_DIRECTIONS.map(func(dir: Vector3) -> Vector3: return cube + dir)

# Get all diagonal neighbors of a cube coordinate
func cube_diagonal_neighbors(cube: Vector3) -> Array[Vector3]:
	return CUBE_DIAGONALS.map(func(dir: Vector3) -> Vector3: return cube + dir)

# Get a line of hexes between two points
func line(a: Vector2i, b: Vector2i) -> Array[Vector2i]:
	var start = axial_to_cube(a)
	var end = axial_to_cube(b)
	var n = cube_distance(Vector3(start), Vector3(end))
	var results: Array[Vector2i] = []
	
	for i in range(0, n + 1):
		var t = 1.0 / max(n, 1) * i
		var cube = cube_round(cube_lerp(Vector3(start), Vector3(end), t))
		results.append(cube_to_axial(cube))
	
	return results

# Get all direct neighbors of a hex
func neighbors(axial: Vector2i) -> Array[Vector2i]:
	var cube = axial_to_cube(axial)
	var result: Array[Vector2i] = []
	print(cube)
	
	for dir_vec in CUBE_DIRECTIONS:
		var neighbor = cube + dir_vec
		print(neighbor)
		result.append(cube_to_axial(neighbor))
	
	print(result)
	return result

# Get all diagonal neighbors of a hex
func diagonals(axial: Vector2i) -> Array[Vector2i]:
	var cube = axial_to_cube(axial)
	var result: Array[Vector2i] = []
	
	for diag_vec in CUBE_DIAGONALS:
		var neighbor = cube + diag_vec
		result.append(cube_to_axial(neighbor))
	
	return result

# Find all reachable hexes within a given movement range
func reachable(start: Vector2i, movement: int, blocked: Array = []) -> Array:
	var visited: Dictionary = {}
	var fringes: Array[Array] = []
	
	visited[start] = start
	fringes.append([start])
	
	for k in range(1, movement + 1):
		fringes.append([])
		for hex in fringes[k - 1]:
			for neighbor in neighbors(hex):
				if not neighbor in visited and not _is_blocked(neighbor, blocked):
					visited[neighbor] = neighbor
					fringes[k].append(neighbor)
	
	visited.erase(start)
	
	return visited.values()

# Helper function to check if a hex is blocked
func _is_blocked(hex: Vector2i, blocked: Array) -> bool:
	for b in blocked:
		if b.x == hex.x and b.y == hex.y:
			return true
	return false
