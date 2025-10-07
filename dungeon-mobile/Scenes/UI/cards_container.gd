extends Control

signal card_played(card)

var CARD_TINY = preload("res://scenes/ui/card_tiny.tscn")

@onready var container = %Container

func _ready() -> void:
	for card in Data.data.character.deck:
		var card_data = Config.cards[card]
		var instance = CARD_TINY.instantiate()
		instance.card = card_data
		container.add_child(instance)
