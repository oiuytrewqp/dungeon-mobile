extends Node3D

var CARD_LARGE = preload("res://scenes/ui/card_large.tscn")

@onready var hex = $Hex
@onready var camera = $Camera3D

var graph = {}
var enemies = {}
var spawns = {}
var character

func _ready() -> void:
	var mission_data = Config.missions[Data.data.current_mission]
	var new_map = load("res://scenes/missions/%s.tscn" %mission_data.map).instantiate()
	add_child(new_map)
	
	for cell_a in new_map.locations:
		var cell = {
			"neighbours": []
		}
		for cell_b in new_map.locations:
			if cell_a.distance_to(cell_b) < 2:
				cell.neighbours.append(Vector2i(cell_b.x, cell_b.y))
		graph[Vector2i(cell_a.x, cell_a.y)] = cell
		
		match new_map.locations[cell_a]:
			"spawn":
				var new_spawn = load("res://scenes/spawn_tile.tscn").instantiate()
				new_spawn.location = cell_a
				new_spawn.selected.connect(_spawn_selected)
				new_spawn.chosen.connect(_spawn_chosen)
				add_child(new_spawn)
				new_spawn.position = hex.axial_to_position(cell_a)
				spawns[cell_a] = new_spawn
	
	for axial in new_map.enemies:
		var type = new_map.enemies[axial]
		var new_enemy = load("res://scenes/characters/chibi_%s.tscn" %type).instantiate()
		new_enemy.character = Config.enemies[type]
		add_child(new_enemy)
		new_enemy.position = hex.axial_to_position(axial)
		new_enemy.get_node("rig").rotation_degrees = Vector3(0, randf() * 360, 0)
		enemies[axial] = new_enemy

func _spawn_selected(location):
	for spawn in spawns:
		spawns[spawn].is_selected = spawn == location

func _spawn_chosen(location):
	for spawn in spawns:
		spawns[spawn].queue_free()
	
	var character = Data.data.character
	
	var model = Config.characters[character.type].model
	
	var new_character = load("res://scenes/characters/chibi_%s.tscn" %model).instantiate()
	new_character.character = character
	add_child(new_character)
	new_character.position = hex.axial_to_position(location)
	new_character.get_node("rig").rotation_degrees = Vector3(0, randf() * 360, 0)
	character = new_character
	
	camera.reparent(character, false)
