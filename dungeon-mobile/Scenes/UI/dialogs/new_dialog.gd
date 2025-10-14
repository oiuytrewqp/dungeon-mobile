extends Control

var CARD_SMALL = preload("res://scenes/ui/card_small.tscn")
var CARD_LARGE = preload("res://scenes/ui/card_large.tscn")

@onready var character_type_label = %CharacterTypeLabel
@onready var portrait_texture = %PortraitTexture
@onready var description_label = %DescriptionLabel
@onready var character_cards_contrainer = %CharacterCardsContainer
@onready var weapon_type_label = %WeaponTypeLabel
@onready var weapon_cards_contrainer = %WeaponCardsContainer
@onready var ok_button = %OkButton

var character_index = 0
var weapon_index = 0

var character_name = ""

func _ready():
	update_character()
	update_weapon()

func update_character() -> void:
	var character = Config.characters[Config.characters.keys()[character_index]]
	
	character_type_label.text = character.type
	
	portrait_texture.texture = load("res://assets/profiles/%s.png" %character.profile)
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
	var weapon = Config.weapons[Config.weapons.keys()[weapon_index]]
	
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

func _on_character_left_pressed():
	character_index -= 1
	if character_index < 0:
		character_index = Config.characters.size() - 1
	update_character()

func _on_character_right_pressed():
	character_index += 1
	if character_index > Config.characters.size() - 1:
		character_index = 0
	update_character()

func _on_weapon_left_pressed():
	weapon_index -= 1
	if weapon_index < 0:
		weapon_index = Config.weapons.size() - 1
	update_weapon()

func _on_weapon_right_pressed():
	weapon_index += 1
	if weapon_index > Config.weapons.size() - 1:
		weapon_index = 0
	update_weapon()

func _on_name_text_changed(new_text: String) -> void:
	character_name = new_text
	
	ok_button.disabled = character_name.length() == 0

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/dialogs/menu_dialog.tscn")

func _on_ok_pressed() -> void:
	Game.new_save(Config.characters.keys()[character_index], character_name, Config.weapons.keys()[weapon_index])
	
	get_tree().change_scene_to_file("res://scenes/main.tscn")
