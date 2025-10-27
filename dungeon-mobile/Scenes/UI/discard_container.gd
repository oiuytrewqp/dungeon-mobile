extends PanelContainer

@onready var background_texture = %BackgroundTexture

func _ready() -> void:
	var current_mission = Game.get_current_mission()
	current_mission.discard_updated.connect(_update)
	_update()

func _update():
	var current_mission = Game.get_current_mission()
	background_texture.visible = current_mission.has_discards()
