extends Node3D

@onready var health_bar = %HealthBar
@onready var health_label = %HealthLabel
@onready var name_label = %NameLabel

var data

func _ready() -> void:
	position = Hex.axial_to_position(Vector2(data.x, data.y))
	rotation_degrees = Vector3(0, randf() * 360, 0)
	name_label.text = data.name

func _update():
	health_bar.value = data.health / data.max_health
	health_label.text = "%s / %s" %[data.health, data.max_health]
