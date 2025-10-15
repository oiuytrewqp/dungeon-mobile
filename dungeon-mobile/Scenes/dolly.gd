extends Node3D

func _process(_delta: float) -> void:
	rotation.y = -get_parent().rotation.y
