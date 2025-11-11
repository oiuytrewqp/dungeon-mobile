class_name MissionData


var _name
var _move_locations : Array[Vector2i]
var _spawn_locations : Array[Vector2i]
var _door_locations : Array[Vector2i]
var _enemies
var _character_location
var _character_rotation
var _character_health_maximum
var _character_health
var _hand
var _discard
var _selected_card_name
var _moves_available
var _actions_available

var _character_path
var _character_moving = false
var _character_attacking = false
var _enemy_turn = false

func setup(name, hand):
	_name = name
	_hand = hand
	_discard = []
	_character_rotation = randf() * 360
	_character_health_maximum = get_character_health_maximum()
	_character_health = _character_health_maximum

func save():
	return {
		"name": _name,
		"move_locations": _move_locations,
		"spawn_locations": _spawn_locations,
		"door_locations": _door_locations,
		"enemies": _enemies,
		"health_maximum": 10,
		"character_location": _character_location,
		"character_rotation": _character_rotation,
		"character_health_maximum": _character_health_maximum,
		"character_health": _character_health,
		"hand": _hand,
		"discard": _discard,
		"selected_card_name": _selected_card_name,
		"moves_available": _moves_available,
		"actions_available": _actions_available,
	}

func load(data):
	_name = data.name
	if data.move_locations != null:
		var move_locations : Array[Vector2i] = []
		for location in data.move_locations:
			move_locations.append(Vector2i(location.x, location.y))
		_move_locations = move_locations
	if data.spawn_locations != null:
		var spawn_locations : Array[Vector2i] = []
		for location in data.spawn_locations:
			spawn_locations.append(Vector2i(location.x, location.y))
		_spawn_locations = spawn_locations
	if data.door_locations != null:
		var door_locations : Array[Vector2i] = []
		for location in data.door_locations:
			door_locations.append(Vector2i(location.x, location.y))
		_door_locations = door_locations
	_enemies = data.enemies
	_character_location = data.character_location
	_character_rotation = data.character_rotation
	_character_health_maximum = data.character_health_maximum
	_character_health = data.character_health
	_hand = data.hand
	_discard = data.discard
	_selected_card_name = data.selected_card_name
	_moves_available = data.moves_available
	_actions_available = data.actions_available

func set_spawn_locations(new_spawn_locations):
	_spawn_locations = new_spawn_locations
	EventBus.spawn_locations_updated.emit()

func set_move_locations(new_move_locations):
	_move_locations = new_move_locations
	Pathfinding.create_graph(_move_locations)

func set_door_locations(new_door_locations):
	_door_locations = new_door_locations
	_update_doors()

func set_enemies(new_enemies):
	_enemies = []
	for enemy in new_enemies:
		var health_maximum = get_enemy_health_maximum(enemy.type)
		var new_enemy = {
			"type": enemy.type,
			"x": enemy.x,
			"y": enemy.y,
			"health_maximum": health_maximum,
			"health": health_maximum,
			"attack": get_enemy_attack(enemy.type),
			"defence": get_enemy_defence(enemy.type),
			"range": get_enemy_range(enemy.type),
			"moves": get_enemy_move(enemy.type),
			"rotation": randf() * 360
		}
		_enemies.append(new_enemy)
	_update_obstacles()
	EventBus.enemies_updated.emit()

func set_character_location(new_location, new_rotation):
	var spawned = _character_location == null
	_character_location = new_location
	_character_rotation = new_rotation
	if spawned:
		EventBus.character_spawned.emit()

func set_selected_card_name(new_card_name):
	if _selected_card_name != null || _enemy_turn:
		return
	
	_selected_card_name = new_card_name
	_discard.append(new_card_name)
	_hand.erase(new_card_name)
	_moves_available = Config.cards[_selected_card_name].moves
	EventBus.selected_card_updated.emit()
	EventBus.hand_updated.emit()
	EventBus.discard_updated.emit()

func move_character(location):
	if _character_moving || _enemy_turn:
		return
	
	_character_moving = true
	_character_path = Pathfinding.find_path(_character_location, location)
	EventBus.character_path_updated.emit()

func character_moved():
	_character_moving = false
	EventBus.character_location_updated.emit()

func set_moves_available(new_moves_available):
	_moves_available = new_moves_available
	EventBus.moves_available_updated.emit()

func enemy_at_location(location):
	for enemy in _enemies:
		if enemy.x == location.x && enemy.y == location.y:
			return true
	
	return false

func attack(location):
	if _character_attacking || _enemy_turn:
		return
	
	_character_attacking = true
	set_moves_available(0)
	EventBus.character_attack.emit(location, Config.cards[_selected_card_name].attack)

func attack_done():
	_selected_card_name = null
	_character_attacking = false
	set_moves_available(0)
	_enemy_turn = true
	EventBus.character_attack_done.emit()

func enemies_done():
	_update_obstacles()
	
	if _hand.size() == 0:
		_hand = _discard
		_discard = []
		EventBus.hand_updated.emit()
		EventBus.discard_updated.emit()
	
	_enemy_turn = false

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

func has_discards():
	return _discard.size() > 0

func discrad_count():
	return _discard.size()

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

func get_character_health():
	return _character_health

func set_character_health(new_health, enemy_location):
	if new_health < 0:
		new_health = 0
	
	var hurt = false
	if new_health < _character_health:
		hurt = true
	
	_character_health = new_health
	EventBus.character_health_update.emit()
	
	if hurt:
		EventBus.charcter_hurt.emit(enemy_location)

func get_character_health_maximum():
	var character_data = Game.get_character()
	var level = character_data.get_level()
	var health_config = Config.characters[character_data.get_character_type()].health
	return int(health_config.base + level * health_config.level)

func get_enemy_health_maximum(enemy_type):
	var character_data = Game.get_character()
	var level = character_data.get_level()
	var health_config = Config.enemies[enemy_type].health
	return int(health_config.base + level * health_config.level)

func get_enemy_attack(enemy_type):
	var character_data = Game.get_character()
	var level = character_data.get_level()
	var attack_config = Config.enemies[enemy_type].attack
	return int(attack_config.base + level * attack_config.level)

func get_enemy_defence(enemy_type):
	var character_data = Game.get_character()
	var level = character_data.get_level()
	var defence_config = Config.enemies[enemy_type].defence
	return int(defence_config.base + level * defence_config.level)

func get_enemy_range(enemy_type):
	var character_data = Game.get_character()
	var level = character_data.get_level()
	var range_config = Config.enemies[enemy_type].range
	return int(range_config.base + level * range_config.level)

func get_enemy_move(enemy_type):
	var character_data = Game.get_character()
	var level = character_data.get_level()
	var move_config = Config.enemies[enemy_type].move
	return int(move_config.base + level * move_config.level)

func is_busy():
	if _character_path != null:
		return true
	
	return false

func _update_obstacles():
	var obstacles = []
	if _enemies != null:
		for enemy in _enemies:
			if enemy.health > 0:
				obstacles.append(Vector2i(enemy.x, enemy.y))
	Pathfinding.update_obstacles(obstacles)

func _update_doors():
	var doors = []
	if _door_locations != null:
		for location in _door_locations:
			doors.append(location)
	Pathfinding.update_doors(doors)
