extends Control

signal back()

var CARD_SMALL = preload("res://scenes/ui/card_small.tscn")
var CARD_LARGE = preload("res://scenes/ui/card_large.tscn")

@onready var character_type_label = %CharacterTypeLabel
@onready var portrait_texture = %PortraitTexture
@onready var name_label = %NameLabel
@onready var level_label = %LevelLabel
@onready var description_label = %DescriptionLabel
@onready var cards_contrainer = %CardsContainer
@onready var weapon_type_label = %WeaponTypeLabel

func _ready():
	update_character()

func update_character() -> void:
	var character = Game.get_character()
	var character_type = character.get_character_type()
	var character_config = Config.characters[character_type]
	
	character_type_label.text = character_type
	
	portrait_texture.texture = load("res://assets/profiles/%s.png" %character_config.profile)
	name_label.text = "Name: %s" %character.get_name()
	level_label.text = "Level: %s" %str(int(character.get_level()))
	description_label.text = character_config.description
	
	for child in cards_contrainer.get_children():
		child.queue_free()
	
	for card_name in character.get_hand():
		var new_card_small = CARD_SMALL.instantiate()
		new_card_small.card = Config.cards[card_name]
		new_card_small.card_pressed.connect(_card_pressed)
		cards_contrainer.add_child(new_card_small)

func _card_pressed(card):
	var new_card_large = CARD_LARGE.instantiate()
	new_card_large.card = card
	add_child(new_card_large)

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/dialogs/menu_dialog.tscn")

func _on_ok_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")
