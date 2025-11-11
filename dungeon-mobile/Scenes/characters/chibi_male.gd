extends Node3D

@onready var health_bar = %HealthBar
@onready var health_label = %HealthLabel
@onready var name_label = %NameLabel
@onready var aniamtion_player = $AnimationPlayer

var isCharacter

var _previous_global_position

func _ready() -> void:
	var character_data = Game.get_character()

	var mission_data = Game.get_current_mission()
	if isCharacter:
		var location = mission_data.get_character_location()
		var character_rotation = mission_data.get_character_rotation()
		position = Hex.axial_to_position(Vector2(location.x, location.y))
		rotation_degrees = Vector3(0, character_rotation, 0)
		name_label.text = character_data.get_name()
		EventBus.character_path_updated.connect(_character_path_updated)
		EventBus.character_attack.connect(_attack)
		EventBus.character_health_update.connect(_update)
		EventBus.charcter_hurt.connect(_hurt)
		_update()
	else:
		pass
	
	_previous_global_position = Vector2(global_position.x, global_position.z)

func _process(delta: float):
	var location2D = Vector2(global_position.x, global_position.z)
	
	if _previous_global_position.is_equal_approx(location2D):
		return
	
	var angle = 90 - rad_to_deg((location2D - _previous_global_position).angle())
	rotation_degrees.y = angle
	
	_previous_global_position = location2D

func _update():
	var mission_data = Game.get_current_mission()
	mission_data.get_character_rotation()
	var health_maximum = mission_data.get_character_health_maximum()
	var health = mission_data.get_character_health()
	health_bar.value = health
	health_bar.max_value = health_maximum
	health_label.text = "%s / %s" %[health, health_maximum]

func _character_path_updated():
	var mission_data = Game.get_current_mission()
	var path = mission_data.get_character_path()
	
	var tween = get_tree().create_tween()
	for step in path:
		tween.tween_property(self, "position", Hex.axial_to_position(Vector2i(step)), 1.0)
	tween.tween_callback(_moved.bind(path.size(), path[-1]))
	
	aniamtion_player.play("WalkSwordShield")

func _moved(moves, location):
	var mission_data = Game.get_current_mission()
	mission_data.set_character_location(location, rotation_degrees.y)
	mission_data.set_moves_available(mission_data.get_moves_available() - moves)
	mission_data.character_moved()
	
	aniamtion_player.play("IdleSwordShield")

func _attack(location, _attack):
	var location2D = Vector2(global_position.x, global_position.z)
	var attack_position = Hex.axial_to_position(location)
	var attack_location = Vector2(attack_position.x, attack_position.z)
	var angle = 90 - rad_to_deg((attack_location - location2D).angle())
	
	rotation_degrees.y = angle
	
	aniamtion_player.play("StabSwordShield")
	
	var tween = get_tree().create_tween()
	tween.tween_interval(2)
	tween.tween_callback(_attack_done)

func _attack_done():
	var mission_data = Game.get_current_mission()
	mission_data.attack_done()

func _hurt(enemy_location):
	var location2D = Vector2(global_position.x, global_position.z)
	var attack_position = Hex.axial_to_position(enemy_location)
	var attack_location = Vector2(attack_position.x, attack_position.z)
	var angle = 90 - rad_to_deg((attack_location - location2D).angle())
	
	rotation_degrees.y = angle
	
	var mission_data = Game.get_current_mission()
	var new_health = mission_data.get_character_health()
	if new_health == 0:
		aniamtion_player.play("DieSwordShield")
		Game.dead()
	else:
		aniamtion_player.play("HurtSwordShield")
	
	var tween = get_tree().create_tween()
	tween.tween_interval(2)
	tween.tween_callback(_idle)

func _idle():
	aniamtion_player.play("IdleSwordShield")
