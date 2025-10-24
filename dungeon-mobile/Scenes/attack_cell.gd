extends Node3D

var location

func _ready() -> void:
	position = Hex.axial_to_position(Vector2i(location.x, location.y))

func _on_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			_pressed()
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			_pressed()

func _pressed():
	Game.get_current_mission().attack(location)
