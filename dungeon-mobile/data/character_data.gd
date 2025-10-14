class_name CharacterData

var _character_type
var _name
var _weapon_type
var _level
var _gold
var _experience
var _armor
var _consumables
var _items
var _deck
var _hand

func setup(character_type, name, weapon_type):
	_character_type = character_type
	_name = name
	_weapon_type = weapon_type
	_level = 0
	_gold = Config.characters[character_type].gold
	_experience = 0
	_armor = Config.characters[character_type].armor
	_consumables = Config.characters[character_type].consumables
	_items = Config.characters[character_type].items
	
	_deck = []
	_hand = []
	for card in Config.characters[character_type].levels["0"].cards:
		_deck.append(card)
		_hand.append(card)
	for card in Config.weapons[weapon_type].levels["0"].cards:
		_deck.append(card)
		_hand.append(card)

func save():
	return {
		"character_type": _character_type,
		"name": _name,
		"weapon_type": _weapon_type,
		"level": _level,
		"gold": _gold,
		"experience": _experience,
		"armor": _armor,
		"consumables": _consumables,
		"items": _items,
		"deck": _deck,
		"hand": _hand,
	}

func load(data):
	_character_type = data.character_type
	_name = data.name
	_weapon_type = data.weapon_type
	_level = data.level
	_gold = data.gold
	_experience = data.experience
	_armor = data.armor
	_consumables = data.consumables
	_items = data.items
	_deck = data.deck
	_hand = data.hand

func get_character_type():
	return _character_type

func get_name():
	return _name

func get_level():
	return _level

func get_gold():
	return _gold

func get_deck():
	return _deck

func get_hand():
	return _hand

func get_weapon_type():
	return _weapon_type
