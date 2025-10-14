class_name MissionData

var _name
var _move_locations
var _enemies
var _spawn_locations
var _character_location
var _character_rotation
var _card_selected
var _moves_available
var _actions_available

func setup(name):
	_name = name

func save():
	return {
		"name": _name,
		"move_locations": _move_locations,
		"enemies": _enemies,
		"spawn_locations": _spawn_locations,
		"character_location": _character_location,
		"character_rotation": _character_rotation,
		"card_selected": _card_selected,
		"moves_available": _moves_available,
		"actions_available": _actions_available,
	}

func load(data):
	_name = data.name
	_move_locations = data.move_locations
	_enemies = data.enemies
	_spawn_locations = data.spawn_locations
	_character_location = data.character_location
	_character_rotation = data.character_rotation
	_card_selected = data.card_selected
	_moves_available = data.moves_available
	_actions_available = data.actions_available

func get_name():
	return _name

func get_move_locations():
	return _move_locations
