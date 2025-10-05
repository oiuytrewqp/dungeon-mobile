extends Node3D

func _ready() -> void:
	var floors = Data._map.floors
	for axial_key in floors:
		var tile_data = floors[axial_key]
		_instantiate_tile(tile_data, Hex.key_to_axial(axial_key))

func _instantiate_tile(tile_type: String, tile_position: Vector2i) -> void:
	var new_position = Hex.axial_to_offset(tile_position)
	
	var scene_path ="res://Assets/models/stationary/%s.tscn" % tile_type
	var scene = load(scene_path)
	if not scene:
		push_error("Failed to load scene: " + scene_path)
		return
	
	var instance = scene.instantiate()
	add_child(instance)
	
	instance.global_position = Vector3(new_position.x + (new_position.y & 1) * 0.5, 0, new_position.y / 1.16)
