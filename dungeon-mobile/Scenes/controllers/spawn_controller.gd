extends Node3D

func _ready() -> void:
	Game.get_current_mission().spawn_locations_updated.connect(_on_spawn_locations_updated)
	Game.get_current_mission().character_spawned.connect(_clear_spawns)

func _clear_spawns():
	for child in get_children():
		child.queue_free()

func _on_spawn_locations_updated():
	_clear_spawns()
	
	var mission_data = Game.get_current_mission()
	var spawn_locations = mission_data.get_spawn_locations()
	for spawn_location in spawn_locations:
		var new_spawn = load("res://scenes/spawn_tile.tscn").instantiate()
		new_spawn.location = spawn_location
		new_spawn.selected.connect(_spawn_selected)
		add_child(new_spawn)

func _spawn_selected(location):
	for child in get_children():
		child.is_selected = child.location == location
