extends Area3D

signal selected(location)

var location

func _on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			_pressed()
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			_pressed()

func _pressed():
		selected.emit(location)
