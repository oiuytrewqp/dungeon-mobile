extends Node3D

var target

func _process(_delta: float) -> void:
	if target != null:
		global_position = target.global_position
