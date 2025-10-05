@tool
extends Node3D

@onready var hex = $Hex

func _process(_delta):
	if Engine.is_editor_hint():
		var axial_position = hex.offset_to_axial(Vector2(position.x, position.z))
		
		var offset_position = hex.axial_to_offset(axial_position)
		
		#position.x = round(position.x)
		#position.z = round(position.z)
		#position.y = 0.1
		
		print(offset_position)
