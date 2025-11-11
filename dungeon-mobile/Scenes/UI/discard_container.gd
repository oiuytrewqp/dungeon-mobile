extends PanelContainer

@onready var background_texture = %BackgroundTexture
@onready var count_label = %CountLabel

func _ready() -> void:
	var current_mission = Game.get_current_mission()
	EventBus.discard_updated.connect(_update)
	_update()

func _update():
	var current_mission = Game.get_current_mission()
	background_texture.visible = current_mission.has_discards()
	count_label.text = str(current_mission.discrad_count())
