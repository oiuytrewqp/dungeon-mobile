extends Node3D

func _ready() -> void:
	Game.on_character_spawns_updated.connect(_on_character_spawns_updated)

func _clear_character_spawns():
	for child in get_children():
		child.queue_free()

func _on_character_spawns_updated(character_spawns):
	_clear_character_spawns()
	
	for spawn_location in character_spawns:
		var new_spawn = load("res://scenes/spawn_tile.tscn").instantiate()
		new_spawn.location = spawn_location
		add_child(new_spawn)

func _spawn_selected(location):
	for child in get_children():
		child.is_selected = child.location == location

func _clear_spawns():
	for child in get_children():
		child.queue_free()

func _spawn_chosen(location):
	_clear_spawns()
	Game.set_character_location(location)
