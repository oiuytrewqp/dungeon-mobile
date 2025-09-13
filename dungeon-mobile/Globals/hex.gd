extends Node

# Axial coordinates (q, r) where q + r + s = 0
class Axial:
		var q: int
		var r: int
		
		func _init(q: int, r: int):
				self.q = q
				self.r = r
		
		func _to_string() -> String:
				return "(%d, %d)" % [q, r]

# Offset coordinates (col, row)
class OffsetCoord:
		var col: int
		var row: int
		
		func _init(col: int, row: int):
				self.col = col
				self.row = row
		
		func _to_string() -> String:
				return "(%d, %d)" % [col, row]

# Cube coordinates (q, r, s) where q + r + s = 0
class Cube:
		var q: int
		var r: int
		var s: int
		
		func _init(q: int, r: int, s: int):
				self.q = q
				self.r = r
				self.s = s
		
		func _to_string() -> String:
				return "(%d, %d, %d)" % [q, r, s]

# Direction vectors for cube coordinates
const CUBE_DIRECTIONS = []

# Diagonal vectors for cube coordinates
const CUBE_DIAGONALS = []

func _ready() -> void:
	CUBE_DIRECTIONS.append_array([
		Cube.new(+1, 0, -1), Cube.new(+1, -1, 0), Cube.new(0, -1, +1),
		Cube.new(-1, 0, +1), Cube.new(-1, +1, 0), Cube.new(0, +1, -1)
	])
	
	CUBE_DIAGONALS.append_array([
		Cube.new(+2, -1, -1), Cube.new(+1, -2, +1), Cube.new(-1, -1, +2),
		Cube.new(-2, +1, +1), Cube.new(-1, +2, -1), Cube.new(+1, +1, -2)
	])

# Convert axial to offset coordinates (odd-r offset)
static func axial_to_offset(axial: Axial) -> OffsetCoord:
		var col = axial.q + (axial.r - (axial.r & 1)) / 2
		return OffsetCoord.new(col, axial.r)

# Convert offset to axial coordinates (odd-r offset)
static func offset_to_axial(offset: OffsetCoord) -> Axial:
		var q = offset.col - (offset.row - (offset.row & 1)) / 2
		return Axial.new(q, offset.row)

# Convert axial to cube coordinates
static func axial_to_cube(axial: Axial) -> Cube:
		return Cube.new(axial.q, axial.r, -axial.q - axial.r)

# Convert cube to axial coordinates
static func cube_to_axial(cube: Cube) -> Axial:
		return Axial.new(cube.q, cube.r)

# Round cube coordinates to the nearest hex
static func cube_round(cube: Cube) -> Cube:
		var q = int(round(cube.q))
		var r = int(round(cube.r))
		var s = int(round(cube.s))
		
		var q_diff = abs(q - cube.q)
		var r_diff = abs(r - cube.r)
		var s_diff = abs(s - cube.s)
		
		if q_diff > r_diff and q_diff > s_diff:
				q = -r - s
		elif r_diff > s_diff:
				r = -q - s
		else:
				s = -q - r
				
		return Cube.new(q, r, s)

# Linear interpolation between two values
static func lerp(a: float, b: float, t: float) -> float:
		return a + (b - a) * t

# Linear interpolation between two cube coordinates
static func cube_lerp(a: Cube, b: Cube, t: float) -> Cube:
		return Cube.new(
				lerp(a.q, b.q, t),
				lerp(a.r, b.r, t),
				lerp(a.s, b.s, t)
		)

# Calculate distance between two cube coordinates
static func cube_distance(a: Cube, b: Cube) -> int:
		return int((abs(a.q - b.q) + abs(a.r - b.r) + abs(a.s - b.s)) / 2)

# Get a line of hexes between two points
static func line(a: Axial, b: Axial) -> Array:
		var start = axial_to_cube(a)
		var end = axial_to_cube(b)
		var n = cube_distance(start, end)
		var results = []
		
		for i in range(0, n + 1):
				var t = 1.0 / max(n, 1) * i
				var cube = cube_round(cube_lerp(start, end, t))
				results.append(cube_to_axial(cube))
		
		return results

# Get all direct neighbors of a hex
static func neighbors(axial: Axial) -> Array:
		var cube = axial_to_cube(axial)
		var result = []
		
		for dir_vec in CUBE_DIRECTIONS:
				var neighbor = Cube.new(
						cube.q + dir_vec.q,
						cube.r + dir_vec.r,
						cube.s + dir_vec.s
				)
				result.append(cube_to_axial(neighbor))
		
		return result

# Get all diagonal neighbors of a hex
static func diagonals(axial: Axial) -> Array:
		var cube = axial_to_cube(axial)
		var result = []
		
		for diag_vec in CUBE_DIAGONALS:
				var neighbor = Cube.new(
						cube.q + diag_vec.q,
						cube.r + diag_vec.r,
						cube.s + diag_vec.s
				)
				result.append(cube_to_axial(neighbor))
		
		return result

# Find all reachable hexes within a given movement range
static func reachable(start: Axial, movement: int, blocked: Array = []) -> Array:
		var visited = {}
		var fringes = []
		
		visited[str(start)] = start
		fringes.append([start])
		
		for k in range(1, movement + 1):
				fringes.append([])
				for hex in fringes[k - 1]:
						for neighbor in neighbors(hex):
								var key = str(neighbor)
								if not key in visited and not _is_blocked(neighbor, blocked):
										visited[key] = neighbor
										fringes[k].append(neighbor)
		
		return visited.values()

# Helper function to check if a hex is blocked
static func _is_blocked(hex: Axial, blocked: Array = []) -> bool:
		for b in blocked:
				if b.q == hex.q and b.r == hex.r:
						return true
		return false
