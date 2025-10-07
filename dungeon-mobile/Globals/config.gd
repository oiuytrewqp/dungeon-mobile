extends Node


var start
var enemies
var characters
var weapons
var missions
var cards

var tile_lut = {
		"floors": {
				1: "floor_stone"
		},
		"obstacles": {
		},
		"spawns": {
		},
		"items": {
		}
}

func _ready() -> void:
	start = _load_json("res://assets/config/start.json")
	enemies = _load_json("res://assets/config/enemies.json")
	characters = _load_json("res://assets/config/characters.json")
	weapons = _load_json("res://assets/config/weapons.json")
	missions = _load_json("res://assets/config/missions.json")
	cards = _load_json("res://assets/config/cards.json")

func _load_json(file_path) -> Dictionary:
	var json_string = FileAccess.get_file_as_string(file_path)
	return JSON.parse_string(json_string)

func get_tile_type(layer_name: String, tile_id: int) -> String:
		if tile_lut[layer_name].has(tile_id):
				return tile_lut[layer_name][tile_id]
		
		return ""
