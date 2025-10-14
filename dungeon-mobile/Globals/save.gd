extends Node

const SAVE_FILE = "user://test.save"

func save_game(data: Dictionary) -> bool:
	var file = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	
	if not file:
		push_error("Failed to open save file for writing: " + SAVE_FILE)
		return false
	
	var json_string = JSON.stringify(data, "  ")
	
	file.store_line(json_string)
	return true

func save_game_exists() -> bool:
	return FileAccess.file_exists(SAVE_FILE)

func load_game() -> Dictionary:
	if not save_game_exists():
		push_error("Save file does not exist: " + SAVE_FILE)
		return {}
	
	var file = FileAccess.open(SAVE_FILE, FileAccess.READ)
	if not file:
		push_error("Failed to open save file for reading: " + SAVE_FILE)
		return {}
	
	var parse_result = JSON.parse_string(file.get_as_text())
	
	if parse_result == null:
		push_error("Failed to parse save file")
		return {}
	
	return parse_result
