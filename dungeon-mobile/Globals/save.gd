extends Node

const SAVE_DIR = "user://saves/"
const SAVE_EXTENSION = ".save"
const START_DATA_PATH = "res://Assets/start.json"

func load_level(filename: String) -> Dictionary:
		var result = {}
		
		var path = "res://Assets/levels/%s.json" % filename
		
		var file = FileAccess.open(path, FileAccess.READ)
		if not file:
				push_error("Failed to open level file: " + path)
				return result
		
		var data = JSON.parse_string(file.get_as_text())
		if data == null:
				push_error("Failed to parse JSON: " + path)
				return result
		
		for layer in data.layers:
				var layer_name = layer.get("name").to_lower()
				var layer_width = int(layer.width)
				var layer_data = layer.data
				
				result[layer_name] = {}
				
				for i in range(layer_data.size()):
						var tile_id = layer_data[i]
						if tile_id == 0:
								continue
						
						var offset = Vector2i(i % layer_width, i / layer_width)
						
						var axial = Hex.offset_to_axial(offset)
						var axial_key = Hex.axial_to_key(axial)
						
						result[layer_name][axial_key] = Config.get_tile_type(layer_name, tile_id)
		
		return result

# Save game data to a file
# filename: Name of the save file (without extension)
# data: The data to save (usually the _data dictionary from data.gd)
# Returns: true if save was successful, false otherwise
func save_game(filename: String, data: Dictionary) -> bool:
	# Ensure the save directory exists
	var dir = DirAccess.open("user://")
	if not dir.dir_exists(SAVE_DIR):
		dir.make_dir(SAVE_DIR)
	
	var file_path = SAVE_DIR + filename + SAVE_EXTENSION
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	
	if not file:
		push_error("Failed to open save file: " + file_path)
		return false
	
	# Convert the data to JSON
	var json_string = JSON.stringify(data, "  ")
	
	# Write the JSON string to the file
	file.store_line(json_string)
	return true

# Check if a save file exists
# filename: Name of the save file (without extension)
# Returns: true if the save file exists, false otherwise
func save_game_exists(filename: String) -> bool:
	var file_path = SAVE_DIR.path_join(filename + SAVE_EXTENSION)
	return FileAccess.file_exists(file_path)

# Load game data from a file
# filename: Name of the save file (without extension)
# Returns: The loaded data as a dictionary, or an empty dictionary if loading failed
func load_game(filename: String) -> Dictionary:
	var file_path = SAVE_DIR.path_join(filename + SAVE_EXTENSION)
	
	# Check if file exists
	if not save_game_exists(filename):
		push_error("Save file does not exist: " + file_path)
		return {}
	
	# Open the file
	var file = FileAccess.open(file_path, FileAccess.READ)
	if not file:
		push_error("Failed to open save file: " + file_path)
		return {}
	
	# Parse the JSON data
	var json = JSON.new()
	var parse_result = json.parse(file.get_as_text())
	
	if parse_result != OK:
		push_error("Failed to parse save file: " + json.get_error_message())
		return {}
	
	# Return the parsed data
	return json.get_data()
