extends Node3D

@onready var dolly = $Dolly
@onready var card_container = %CardsContainer

var enemy_scenes = {}
var character_scene

var moveables = []

func _ready() -> void:
	var mission_data = Game.get_current_mission()
	if mission_data.is_character_spawned():
		_on_character_spawned()
	else:
		mission_data.character_spawned.connect(_on_character_spawned)
	
	add_child(load("res://scenes/missions/%s.tscn" %Config.missions[mission_data.get_name()].map).instantiate())
	
	mission_data.character_path_updated.connect(_character_path_updated)

func _on_character_spawned():
	_spawn_character()
	_reparent_dolly()

func _spawn_character():
	var character = Game.get_character()
	var mission_data = Game.get_current_mission()
	var model = Config.characters[character.get_character_type()].model
	
	character_scene = load("res://scenes/characters/chibi_%s.tscn" %model).instantiate()
	character_scene.position = Hex.axial_to_position(mission_data.get_character_location())
	character_scene.rotation_degrees = Vector3(0, mission_data.get_character_rotation(), 0)
	add_child(character_scene)

func _reparent_dolly():
	dolly.reparent(character_scene, false)

func _character_path_updated():
	var mission_data = Game.get_current_mission()
	var path = mission_data.get_character_path()
	
	var tween = get_tree().create_tween()
	for step in path:
		tween.tween_property(character_scene, "position", Hex.axial_to_position(Vector2i(step)), 1.0)
	tween.tween_callback(_moved)
	
	mission_data.set_character_location(path[-1], randf_range(0, 360))
	mission_data.set_moves_available(mission_data.get_moves_available() - path.size())

func _moved():
	print("moved")

"""
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


"""
