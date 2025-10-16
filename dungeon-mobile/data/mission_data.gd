class_name MissionData

signal spawn_locations_updated()
signal enemies_updated()
signal character_spawned()
signal selected_card_updated()
signal character_path_updated()
signal moves_available_updated()
signal hand_updated()

var _name
var _move_locations : Array[Vector2i]
var _spawn_locations : Array[Vector2i]
var _door_locations : Array[Vector2i]
var _enemies
var _character_location
var _character_rotation
var _hand
var _discard
var _selected_card_name
var _moves_available
var _actions_available

var _character_path

func setup(name, hand):
	_name = name
	_hand = hand

func save():
	return {
		"name": _name,
		"move_locations": _move_locations,
		"spawn_locations": _spawn_locations,
		"door_locations": _door_locations,
		"enemies": _enemies,
		"character_location": _character_location,
		"character_rotation": _character_rotation,
		"hand": _hand,
		"discard": _discard,
		"selected_card_name": _selected_card_name,
		"moves_available": _moves_available,
		"actions_available": _actions_available,
	}

func load(data):
	_name = data.name
	if data.move_locations != null:
		var move_locations = []
		for location in data.move_locations:
			move_locations.append(Vector2i(location.x, location.y))
		_move_locations = move_locations
	if data.spawn_locations != null:
		var spawn_locations = []
		for location in data.spawn_locations:
			spawn_locations.append(Vector2i(location.x, location.y))
		_spawn_locations = spawn_locations
	if data.door_locations != null:
		var door_locations = []
		for location in data.door_locations:
			door_locations.append(Vector2i(location.x, location.y))
		_door_locations = door_locations
	_enemies = data.enemies #TODO: convert to Vector2 safely
	_character_location = data.character_location #TODO: convert to Vector2 safely
	_character_rotation = data.character_rotation #TODO: convert to Vector2 safely
	_hand = data.hand
	_discard = data.discard
	_selected_card_name = data.selected_card_name
	_moves_available = data.moves_available
	_actions_available = data.actions_available

func set_spawn_locations(new_spawn_locations):
	_spawn_locations = new_spawn_locations
	spawn_locations_updated.emit()

func set_move_locations(new_move_locations):
	_move_locations = new_move_locations
	Pathfinding.create_graph(_move_locations)

func set_door_locations(new_door_locations):
	_door_locations = new_door_locations
	_update_doors()

func set_enemies(new_enemies):
	_enemies = new_enemies
	_update_obstacles()
	enemies_updated.emit()

func set_character_location(new_location, new_rotation):
	var spawned = _character_location == null
	_character_location = new_location
	_character_rotation = new_rotation
	if spawned:
		character_spawned.emit()

func set_selected_card_name(new_card_name):
	_selected_card_name = new_card_name
	_moves_available = Config.cards[_selected_card_name].moves
	selected_card_updated.emit()

func move_character(location):
	_character_path = Pathfinding.find_path(_character_location, location)
	character_path_updated.emit()

func set_moves_available(new_moves_available):
	_moves_available = new_moves_available
	moves_available_updated.emit()

func get_name():
	return _name

func get_spawn_locations():
	return _spawn_locations

func get_move_locations():
	return _move_locations

func get_enemies():
	return _enemies

func get_hand():
	return _hand

func get_selected_card_name():
	return _selected_card_name

func is_character_spawned():
	return _character_location != null

func get_character_location():
	return _character_location

func get_character_rotation():
	return _character_rotation

func get_moves_available():
	return _moves_available

func get_character_path():
	return _character_path

func is_busy():
	if _character_path != null:
		return true
	
	return false

func _update_obstacles():
	var obstacles = []
	if _enemies != null:
		for location in _enemies:
			obstacles.append(Vector2i(location.x, location.y))
	Pathfinding.update_obstacles(obstacles)

func _update_doors():
	var doors = []
	if _door_locations != null:
		for location in _door_locations:
			doors.append(location)
	Pathfinding.update_doors(doors)
