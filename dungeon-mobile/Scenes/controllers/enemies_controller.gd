extends Node3D

func _ready() -> void:
	Game.get_current_mission().enemies_updated.connect(_on_enemies_updated)

func _clear_enemies():
	for child in get_children():
		child.queue_free()

func _on_enemies_updated():
	_clear_enemies()
	
	var mission_data = Game.get_current_mission()
	var enemies = mission_data.get_enemies()
	for enemy in enemies:
		var new_enemy = load("res://scenes/characters/chibi_%s.tscn" %enemy.type).instantiate()
		add_child(new_enemy)
		new_enemy.position = Hex.axial_to_position(Vector2(enemy.x, enemy.y))
		new_enemy.get_node("rig").rotation_degrees = Vector3(0, randf() * 360, 0)
