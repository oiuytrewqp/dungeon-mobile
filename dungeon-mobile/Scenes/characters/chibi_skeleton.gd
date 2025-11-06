extends Node3D

signal done_performing_action()

@onready var health_bar = %HealthBar
@onready var health_label = %HealthLabel
@onready var name_label = %NameLabel
@onready var aniamtion_player = $AnimationPlayer

var enemy_data

var _previous_global_position

func _ready() -> void:
	position = Hex.axial_to_position(Vector2(enemy_data.x, enemy_data.y))
	rotation_degrees = Vector3(0, randf() * 360, 0)
	name_label.text = Config.enemies[enemy_data.type].name
	_update()
	
	_previous_global_position = Vector2(global_position.x, global_position.z)

func _process(_delta: float) -> void:
	var location2D = Vector2(global_position.x, global_position.z)
	
	if _previous_global_position.is_equal_approx(location2D):
		return
	
	var angle = 90 - rad_to_deg((location2D - _previous_global_position).angle())
	rotation_degrees.y = angle
	
	_previous_global_position = location2D

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
		print(name, " moves ", path.size())
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
		print(name, " doesnt move")
		_moved(0, location)

func _moved(_moves, location):
	var mission_data = Game.get_current_mission()
	enemy_data.x = location.x
	enemy_data.y = location.y
	
	var character_location = mission_data.get_character_location()
	var neighbours = Hex.neighbors(location)
	for neighbour in neighbours:
		if neighbour.x == character_location.x && neighbour.y == character_location.y:
			var character_position = Hex.axial_to_position(character_location)
			_previous_global_position = Vector2(global_position.x + global_position.x - character_position.x, global_position.z + global_position.z - character_position.z)
			aniamtion_player.play("StabSword")
			var tween = get_tree().create_tween()
			tween.tween_interval(2)
			tween.tween_callback(_attack_done)
			print(name, " attacks")
			return
	
	aniamtion_player.play("IdleSword")
	done_performing_action.emit()

func _attack_done():
	var mission_data = Game.get_current_mission()
	mission_data.set_character_health(mission_data.get_character_health() - enemy_data.attack, Vector2(enemy_data.x, enemy_data.y))
	done_performing_action.emit()
