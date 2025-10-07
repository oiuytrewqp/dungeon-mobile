extends Node3D

@onready var hex = $Hex

var graph = {}

func _ready() -> void:
	var mission_data = Config.missions[Data.data.current_mission]
	var new_map = load("res://scenes/missions/%s.tscn" %mission_data.map).instantiate()
	add_child(new_map)
	
	for cell_a in new_map.locations:
		var cell = {
			"neighbours": []
		}
		for cell_b in new_map.locations:
			if cell_a.distance_to(cell_b) < 2:
				cell.neighbours.append(Vector2i(cell_b.x, cell_b.y))
		graph[Vector2i(cell_a.x, cell_a.y)] = cell
	
	for axial in new_map.enemies:
		var type = new_map.enemies[axial]
		var new_enemy = load("res://scenes/characters/chibi_%s.tscn" %type).instantiate()
		new_enemy.enemy = Config.enemies[type]
		add_child(new_enemy)
		new_enemy.position = hex.axial_to_position(axial)
		new_enemy.rotation_degrees = Vector3(0, randf() * 360, 0)
