extends Node3D

var _current_index = 0

func _ready():
	var mission_data = Game.get_current_mission()
	EventBus.enemies_updated.connect(_on_enemies_updated)
	EventBus.character_attack.connect(_attack)
	EventBus.character_attack_done.connect(_enemy_actions)

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
		new_enemy.done_performing_action.connect(_enemy_actions)
		add_child(new_enemy)

func _attack(location, attack):
	for enemy in get_children():
		var enemy_location = enemy.get_location()
		if enemy_location.x == location.x && enemy_location.y == location.y:
			enemy.damage(attack)

func _enemy_turn():
	var child = get_children()[_current_index]
	_current_index += 1
	child.perform_action()

func _enemy_actions():
	var enemy_count = get_child_count()
	
	if enemy_count == 0:
		Game.no_enemies()
	
	if _current_index >= enemy_count:
		_current_index = 0
		var mission_data = Game.get_current_mission()
		mission_data.enemies_done()
	else:
		_enemy_turn()
