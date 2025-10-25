extends Node3D

func _ready() -> void:
	Game.get_current_mission().enemies_updated.connect(_on_enemies_updated)
	Game.get_current_mission().character_attack.connect(_attack)

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
		add_child(new_enemy)

func _attack(location, attack):
	for enemy in get_children():
		var enemy_location = enemy.get_location()
		if enemy_location.x == location.x && enemy_location.y == location.y:
			enemy.damage(attack)
