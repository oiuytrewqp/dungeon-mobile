extends Node

signal hand_updated()
signal playing_updated()

var save_name = "test"

var data

func _ready() -> void:
	if Save.save_game_exists(save_name):
		data = Save.load_game(save_name)

func play_card(card):
	data.character.playing = {
		"card": card,
		"moved": false,
		"action": 0
	}
	playing_updated.emit()
	data.character.hand.erase(card)
	hand_updated.emit()

func new_save(new_character_type, new_name, new_weapon_type) -> void:
	var deck = []
	var hand = []
	for card in Config.characters[new_character_type].levels["0"].cards:
		deck.append(card)
		hand.append(card)
	for card in Config.weapons[new_weapon_type].levels["0"].cards:
		deck.append(card)
		hand.append(card)
	
	data = {
		"character": {
			"type": new_character_type,
			"weapon_type": new_weapon_type,
			"name": new_name,
			"level": 0,
			"gold": 10,
			"experience": 0,
			"armor": null,
			"consumables": [],
			"items": [],
			"deck": deck,
			"hand": hand,
			"discard": [],
			"playing": null,
			"location": null
		},
		"next_missions": ["start"],
		"completed": [],
		"current_mission": null
	}
	
	save()

func save() -> void:
	Save.save_game(save_name, data)
