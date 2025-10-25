extends Node3D

@onready var dolly = $Dolly
@onready var card_container = %CardsContainer

func _ready() -> void:
	var mission_data = Game.get_current_mission()
	if mission_data.is_character_spawned():
		_on_character_spawned()
	else:
		mission_data.character_spawned.connect(_on_character_spawned)
	
	add_child(load("res://scenes/missions/%s.tscn" %Config.missions[mission_data.get_name()].map).instantiate())

func _on_character_spawned():
	var character = Game.get_character()
	var model = Config.characters[character.get_character_type()].model
	
	var character_scene = load("res://scenes/characters/chibi_%s.tscn" %model).instantiate()
	character_scene.isCharacter = true
	add_child(character_scene)
	dolly.reparent(character_scene, false)
