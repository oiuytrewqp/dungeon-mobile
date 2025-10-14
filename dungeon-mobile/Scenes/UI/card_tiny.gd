extends PanelContainer

signal pressed(card)

@onready var background_texture = %BackgroundTexture
@onready var border_texture = %BorderTexture
@onready var move_label = %MoveLabel
@onready var attack_label = %AttackLabel
@onready var name_label = %NameLabel
@onready var description_edit = %DescriptionText

var card

func _ready() -> void:
	var card_data = Config.cards[card]
	
	background_texture.texture = load("res://assets/cards/%sTiny.png" %card_data.card_image)
	border_texture.texture = load("res://assets/cards/%sTiny.png" %card_data.border_image)
	move_label.text = str(int(card_data.moves))
	attack_label.text = str(int(card_data.attack))
	name_label.text = card_data.name
	description_edit.text = card_data.description

func _on_pressed() -> void:
	pressed.emit(card)
