extends Node3D

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
