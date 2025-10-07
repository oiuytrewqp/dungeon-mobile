extends Control

signal back()

var CARD_SMALL = preload("res://scenes/ui/card_small.tscn")
var CARD_LARGE = preload("res://scenes/ui/card_large.tscn")

@onready var character_type_label = %CharacterTypeLabel
@onready var portrait_texture = %PortraitTexture
@onready var name_label = %NameLabel
@onready var level_label = %LevelLabel
@onready var description_label = %DescriptionLabel
@onready var character_cards_contrainer = %CharacterCardsContainer
@onready var weapon_type_label = %WeaponTypeLabel
@onready var weapon_cards_contrainer = %WeaponCardsContainer

func _ready():
	update_character()
	update_weapon()

func update_character() -> void:
	var character = Config.characters[Data.data.character.type]
	
	character_type_label.text = character.type
	
	portrait_texture.texture = load("res://assets/profiles/%s.png" %character.profile)
	name_label.text = "Name: %s" %Data.data.character.name
	level_label.text = "Level: %s" %str(int(Data.data.character.level))
	description_label.text = character.description
	
	for child in character_cards_contrainer.get_children():
		child.queue_free()
	
	var cards = character.levels["0"].cards
	for card_name in cards:
		var new_card_small = CARD_SMALL.instantiate()
		new_card_small.card = Config.cards[card_name]
		new_card_small.card_pressed.connect(_card_pressed)
		character_cards_contrainer.add_child(new_card_small)

func update_weapon() -> void:
	var weapon = Config.weapons[Data.data.character.weapon_type]
	
	weapon_type_label.text = weapon.type
	
	for child in weapon_cards_contrainer.get_children():
		child.queue_free()
	
	var cards = weapon.levels["0"].cards
	for card_name in cards:
		var new_card_small = CARD_SMALL.instantiate()
		new_card_small.card = Config.cards[card_name]
		new_card_small.card_pressed.connect(_card_pressed)
		weapon_cards_contrainer.add_child(new_card_small)

func _card_pressed(card):
	var new_card_large = CARD_LARGE.instantiate()
	new_card_large.card = card
	add_child(new_card_large)

func _on_back_pressed() -> void:
	back.emit()

func _on_ok_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")
