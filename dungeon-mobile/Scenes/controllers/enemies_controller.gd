extends Node3D

var _current_index = 0

func _ready() -> void:
	Game.get_current_mission().enemies_updated.connect(_on_enemies_updated)
	Game.get_current_mission().character_attack.connect(_attack)
	Game.get_current_mission().character_attack_done.connect(_enemy_turn)

func _clear_enemies():
	for child in get_children():
		child.queue_free()

func _on_enemies_updated():
	_clear_enemies()
	
	var mission_data = Game.get_current_mission()
	var enemies = mission_data.get_enemies()
	for enemy in enemies:
		var new_enemy = load("res://scenes/characters/chibi_%s.tscn" %enemy.type).instantiate()
		new_enemy.enemy_data = enemy
		new_enemy.done_performing_action.connect(_enemy_action_done)
		add_child(new_enemy)

func _attack(location, attack):
	for enemy in get_children():
		var enemy_location = enemy.get_location()
		if enemy_location.x == location.x && enemy_location.y == location.y:
			enemy.damage(attack)

func _enemy_turn():
	var child = get_children()[_current_index]
	child.perform_action()

func _enemy_action_done():
	_current_index += 1
	if _current_index >= get_child_count():
		_current_index = 0
		var mission_data = Game.get_current_mission()
		mission_data.enemies_done()
	else:
		_enemy_turn()
