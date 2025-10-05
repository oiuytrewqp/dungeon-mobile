extends PanelContainer

signal selected(mission)

@onready var texture = %Texture
@onready var name_label = %NameLabel
@onready var description_lable = %DescriptionLabel

var mission

func _ready() -> void:
	var mission_data = Config.missions[mission]
	texture.texture = load("res://assets/ui/%s.png" %mission_data.image)
	name_label.text = mission_data.name
	description_lable.text = mission_data.description


func _on_pressed() -> void:
	selected.emit(mission)
