extends Node3D

func _ready() -> void:
	Game.get_current_mission().enemies_updated.connect(_on_enemies_updated)

func _clear_enemies():
	for child in get_children():
		child.queue_free()

func _on_enemies_updated():
	_clear_enemies()
	
	var character_level = Game.get_character().get_level()
	
	var mission_data = Game.get_current_mission()
	var enemies = mission_data.get_enemies()
	for enemy in enemies:
		var enemy_config = Config.enemies[enemy.type]
		var health_config = enemy_config.health
		var health = _value(health_config.base, health_config.level, character_level)
		var attack_config = enemy_config.attack
		var defence_config = enemy_config.defence
		var range_config = enemy_config.range
		var enemy_data = {
			"name": enemy_config.name,
			"x": enemy.x,
			"y": enemy.y,
			"max_health": health,
			"health": health,
			"attack": _value(attack_config.base, attack_config.level, character_level),
			"defence": _value(defence_config.base, defence_config.level, character_level),
			"range": _value(range_config.base, range_config.level, character_level)
		}
		var new_enemy = load("res://scenes/characters/chibi_%s.tscn" %enemy.type).instantiate()
		new_enemy.data = enemy_data
		add_child(new_enemy)

func _value(base, increase, level):
	return int(base + increase * level)
