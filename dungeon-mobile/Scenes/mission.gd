extends Node3D

@onready var camera = $Camera3D
@onready var card_container = %CardsContainer

var enemy_scenes = {}
var character_scene

var moveables = []

func _ready() -> void:
	if Game.character_spawned():
		_on_character_spawned()
	else:
		Game.on_character_spawned.connect(_on_character_spawned)
	
	add_child(load("res://scenes/missions/%s.tscn" %Game.get_current_map_name()).instantiate())

func _on_character_spawned():
	_spawn_character()
	_reparent_camera()

func _spawn_character():
	var model = Config.characters[Game.get_character_type()].model
	
	character_scene = load("res://scenes/characters/chibi_%s.tscn" %model).instantiate()
	character_scene.position = Game.get_character_position()
	add_child(character_scene)

func _reparent_camera():
	camera.reparent(character_scene, false)

func _on_card_played(card: Variant) -> void:
	Game.play_card(card)
	
	var card_data = Config.cards[card]
	if card_data.moves == 0:
		return
	
	var character = Game.data.character
	
	var blocked = []
	for axial in enemy_scenes:
		blocked.append(axial)
	
	var reachable = Hex.reachable(Vector2i(character.location.x, character.location.y), character.playing.moves, blocked)
	
	var valid_reachable = Pathfinding.filter_locations(reachable)
	
	for moveable in valid_reachable:
		var new_moveable = load("res://scenes/moveable.tscn").instantiate()
		new_moveable.position = Hex.axial_to_position(moveable)
		new_moveable.location = moveable
		new_moveable.selected.connect(_move_selected)
		add_child(new_moveable)
		moveables.append(new_moveable)

func _move_selected(location):
	var character_location = Vector2i(Game.data.character.location.x, Game.data.character.location.y)
	var path = Pathfinding.find_path(character_location, location)
	
	var tween = get_tree().create_tween()
	for step in path:
		tween.tween_property(Game.data.character, "position", Hex.axial_to_position(Vector2i(step)), 1.0)
	tween.tween_callback(_moved)
	
	Game.data.character.location.x = path[-1].x
	Game.data.character.location.y = path[-1].y
	
	Game.data.character.playing.moves -= path.size()

func _moved():
	print("moved")
