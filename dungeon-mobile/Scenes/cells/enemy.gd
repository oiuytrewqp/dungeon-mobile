@tool
extends Node3D

@onready var hex = $Hex

@export var editor = true
@export_enum("skeleton", "necromancer") var type: String = "skeleton"

var t = 0
var old_position = Vector3.ZERO

var data = {
	"type": "enemy",
	"x": 0,
	"y": 0,
	"enemy": "skeleton"
}

func _process(delta):
	if editor && Engine.is_editor_hint():
		if data.enemy != type:
			data.enemy = type
		if t != null && position != old_position:
			t += delta
			if t > 0.5:
				t = 0
				
				position.y = 0.15
				data.y = round(position.z / 1.495512)
				position.z = data.y * 1.495512
				var x = 0
				if int(data.y) & 1 == 0:
					data.x = round(position.x / 1.730272)
					x = data.x * 1.730272
				else:
					data.x = round((position.x + 0.865136) / 1.730272)
					x = data.x * 1.730272 - 0.865136
				position.x = x
				
				print(data.x, ", ", data.y)
