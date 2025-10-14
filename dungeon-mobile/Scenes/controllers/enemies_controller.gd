extends Node3D

func _ready() -> void:
	Game.on_enemies_updated.connect(_on_enemies_updated)

func _on_enemies_updated(enemies):
	for enemy in enemies:
		var new_enemy = load("res://scenes/characters/chibi_%s.tscn" %enemy.type).instantiate()
		add_child(new_enemy)
		new_enemy.position = Hex.axial_to_position(Vector2(enemy.x, enemy.y))
		new_enemy.get_node("rig").rotation_degrees = Vector3(0, randf() * 360, 0)
