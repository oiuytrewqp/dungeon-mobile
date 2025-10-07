extends Node3D

var locations = {}
var enemies = {}

func _ready() -> void:
	for child in get_children():
		if "data" in child:
			if child.data.type == "enemy":
				locations[Vector2i(child.data.x, child.data.y)] = "move"
				enemies[Vector2i(child.data.x, child.data.y)] = child.data.enemy
			else:
				locations[Vector2i(child.data.x, child.data.y)] = child.data.type
