extends Node

signal character_dead()
signal mission_success()

var _data

func _ready() -> void:
	if Save.save_game_exists():
		var save_data = Save.load_game()
		
		var new_character = CharacterData.new()
		new_character.load(save_data.character_data)
		
		var new_current_mission = null
		if save_data.current_mission != null:
			new_current_mission = MissionData.new()
			new_current_mission.load(save_data.current_mission)
		
		_data = {
			"character": new_character,
			"previous_mission": save_data.previous_mission,
			"completed_missions": save_data.completed_missions,
			"current_mission": new_current_mission,
		}

func save_game_loaded():
	return _data != null

func new_save(new_character_type, new_name, new_weapon_type) -> void:
	var new_character = CharacterData.new()
	new_character.setup(new_character_type, new_name, new_weapon_type)
	
	_data = {
		"character": new_character,
		"previous_mission": "none",
		"completed_missions": [],
		"current_mission": null,
	}
	save()

func save() -> void:
	var save_data = {
		"character_data": _data.character.save(),
		"previous_mission": _data.previous_mission,
		"completed_missions": _data.completed_missions,
		"current_mission": _data.current_mission.save() if _data.current_mission != null else null,
	}
	Save.save_game(save_data)

func get_character():
	return _data.character

func get_previous_mission():
	return _data.previous_mission

func get_completed_missions():
	return _data.completed_missions

func get_current_mission():
	return _data.current_mission

func set_current_mission(new_current_mission):
	_data.current_mission = MissionData.new()
	_data.current_mission.setup(new_current_mission, get_character().get_hand())
	
	save()

func dead():
	_data.current_mission = null
	
	character_dead.emit()

func no_enemies():
	_data.previous_mission = _data.current_mission
	_data.completed_missions.append(_data.current_mission)
	_data.current_mission = null
	
	mission_success.emit()
