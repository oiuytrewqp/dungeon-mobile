extends HBoxContainer

signal card_played(card)

const CARD = preload("res://Scenes/UI/card.tscn")

func _ready() -> void:
	for i in 5:
		var instance = CARD.instantiate()
		add_child(instance)
