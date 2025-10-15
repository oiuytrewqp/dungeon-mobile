class_name MissionData

signal spawn_locations_updated()
signal enemies_updated()
signal character_spawned()
signal selected_card_updated()
signal hand_updated()

var _name
var _move_locations
var _spawn_locations
var _door_locations
var _enemies
var _character_location
var _character_rotation
var _hand
var _discard
var _selected_card_name
var _moves_available
var _actions_available

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
	_move_locations = data.move_locations
	_spawn_locations = data.spawn_locations
	_door_locations = data.door_locations
	_enemies = data.enemies
	_character_location = data.character_location
	_character_rotation = data.character_rotation
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

func set_enemies(new_enemies):
	_enemies = new_enemies
	enemies_updated.emit()

func set_character_location(new_location):
	_character_location = new_location
	_character_rotation = randf_range(0, 360)
	character_spawned.emit()

func set_selected_card_name(new_card_name):
	_selected_card_name = new_card_name
	_moves_available = Config.cards[_selected_card_name].moves
	selected_card_updated.emit()

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
