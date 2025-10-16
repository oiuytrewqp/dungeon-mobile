extends Node3D

func _ready() -> void:
	var spawn_locations : Array[Vector2i] = []
	var move_locations : Array[Vector2i] = []
	var door_locations : Array[Vector2i] = []
	var enemies = []
	
	for child in get_children():
		if "data" in child:
			move_locations.append(Vector2i(child.data.x, child.data.y))
			match child.data.type:
				"spawn":
					spawn_locations.append(Vector2i(child.data.x, child.data.y))
				"enemy":
					enemies.append({
						"x": child.data.x,
						"y": child.data.y,
						"type": child.data.enemy
					})
				"door":
					door_locations.append(Vector2i(child.data.x, child.data.y))
	
	var mission_data = Game.get_current_mission()
	mission_data.set_spawn_locations(spawn_locations)
	mission_data.set_move_locations(move_locations)
	mission_data.set_door_locations(door_locations)
	mission_data.set_enemies(enemies)
