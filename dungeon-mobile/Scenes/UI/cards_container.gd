extends Control

var CARD_TINY = preload("res://scenes/ui/card_tiny.tscn")
var CARD_LARGE = preload("res://scenes/ui/card_large.tscn")

@onready var container = %Container

func _ready() -> void:
	var mission_data = Game.get_current_mission()

	EventBus.character_spawned.connect(_show)
	EventBus.hand_updated.connect(_update)
	
	_update()

func _show():
	visible = true

func _update():
	for child in container.get_children():
		child.queue_free()
	
	for card in Game.get_current_mission().get_hand():
		var instance = CARD_TINY.instantiate()
		instance.card = card
		instance.pressed.connect(_card_pressed)
		container.add_child(instance)

func _card_pressed(card):
	var new_card_large = CARD_LARGE.instantiate()
	new_card_large.card = card
	new_card_large.pressed.connect(_on_played)
	add_child(new_card_large)

func _on_played(card):
	Game.get_current_mission().set_selected_card_name(card)
