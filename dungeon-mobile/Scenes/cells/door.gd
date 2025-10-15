@tool
extends Node3D

@onready var hex = $Hex

@export var editor = true
@export var location: Vector2i = Vector2i.ZERO

var t = 0
var old_position = Vector3.ZERO

var data = {
	"type": "door",
	"x": 0,
	"y": 0,
}

func _ready() -> void:
	visible = editor && Engine.is_editor_hint()
	_update()

func _process(delta):
	if editor && Engine.is_editor_hint():
		if t != null && position != old_position:
			t += delta
			if t > 0.5:
				t = 0
				
				_update()

func _update():
	var axial = Hex.position_to_axial(position)
	position = Hex.axial_to_position(axial)
	position.y = 0.15
	data.x = axial.x
	data.y = axial.y
	location = axial
