extends Button

signal card_pressed(card)

@onready var background_texture = %BackgroundTexture
@onready var border_texture = %BorderTexture
@onready var move_label = %MoveLabel
@onready var attack_label = %AttackLabel
@onready var name_label = %NameLabel
@onready var description_edit = %DescriptionText

var card

func _ready() -> void:
	background_texture.texture = load("res://assets/cards/%sSmall.png" %card.card_image)
	border_texture.texture = load("res://assets/cards/%sSmall.png" %card.border_image)
	move_label.text = str(int(card.moves))
	attack_label.text = str(int(card.attack))
	name_label.text = card.name
	description_edit.text = card.description

func _on_pressed() -> void:
	card_pressed.emit(card)
