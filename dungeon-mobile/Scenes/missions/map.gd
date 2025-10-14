extends Node3D

func _ready() -> void:
	var spawn_locations = []
	var move_locations = []
	var door_locations = []
	var enemies = []
	
	for child in get_children():
		if "data" in child:
			move_locations.append(Vector2i(child.data.x, child.data.y))
			match child.data.type:
				"spawn":
					spawn_locations.append(Vector2i(child.data.x, child.data.y))
				"enemy":
					enemies.append({
						"x": child.data.enemy.x,
						"y": child.data.enemy.y,
						"type": child.data.enemy.enemy
					})
				"door":
					door_locations.append(Vector2i(child.data.x, child.data.y))
	
	Game.set_spawn_locations(spawn_locations)
	Game.set_map_move_locations(move_locations)
	Game.set_door_locations(door_locations)
	Game.set_map_enemies(enemies)
