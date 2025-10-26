extends Node3D

signal done_performing_action()

@onready var health_bar = %HealthBar
@onready var health_label = %HealthLabel
@onready var name_label = %NameLabel
@onready var aniamtion_player = $AnimationPlayer

var enemy_data

func _ready() -> void:
	position = Hex.axial_to_position(Vector2(enemy_data.x, enemy_data.y))
	rotation_degrees = Vector3(0, randf() * 360, 0)
	name_label.text = Config.enemies[enemy_data.type].name
	_update()

func _update():
	health_bar.max_value = enemy_data.health_maximum
	health_bar.value = enemy_data.health
	health_label.text = "%s / %s" %[enemy_data.health, enemy_data.health_maximum]

func get_location():
	return Vector2(enemy_data.x, enemy_data.y)

func damage(amount):
	enemy_data.health -= amount
	if enemy_data.health <= 0:
		enemy_data.health = 0
		
		aniamtion_player.play("DieSword")
		
		var tween = get_tree().create_tween()
		tween.tween_interval(1)
		tween.tween_callback(queue_free)
	else:
		aniamtion_player.play("HurtSword")
	
	_update()

func perform_action():
	var mission_data = Game.get_current_mission()
	
	var location = Vector2(enemy_data.x, enemy_data.y)
	var player_location = Vector2(mission_data.get_character_location().x, mission_data.get_character_location().y)
	
	var path = Pathfinding.find_path(location, player_location)
	path.pop_back()
	
	if path.size() > 0:
		var moves = []
		for i in enemy_data.moves:
			if path.size() > i:
				moves.append(path[i])
		
		var tween = get_tree().create_tween()
		for step in moves:
			tween.tween_property(self, "position", Hex.axial_to_position(Vector2i(step)), 1.0)
		tween.tween_callback(_moved.bind(moves.size(), moves[-1]))
		
		aniamtion_player.play("WalkSword")
	else:
		done_performing_action.emit()

func _moved(moves, location):
	var mission_data = Game.get_current_mission()
	enemy_data.x = location.x
	enemy_data.y = location.y
	
	var character_location = mission_data.get_character_location()
	var neighbours = Hex.neighbors(location)
	for neighbour in neighbours:
		if neighbour.x == character_location.x && neighbour.y == character_location.y:
			aniamtion_player.play("StabSword")
			var tween = get_tree().create_tween()
			tween.tween_interval(2)
			tween.tween_callback(_attack_done)
			return
	
	aniamtion_player.play("IdleSword")
	done_performing_action.emit()

func _attack_done():
	var mission_data = Game.get_current_mission()
	mission_data.set_character_health(mission_data.get_character_health() - 3)
	done_performing_action.emit()
