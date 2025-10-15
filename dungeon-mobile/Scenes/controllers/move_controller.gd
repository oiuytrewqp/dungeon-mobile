extends Node3D

func _ready() -> void:
	var mission_data = Game.get_current_mission()
	mission_data.selected_card_updated.connect(_show_move_locations)

func _clear():
	for child in get_children():
		child.queue_free()

func _show_move_locations():
	_clear()
	
	var mission_data = Game.get_current_mission()
	var character_location = mission_data.get_character_location()
	var moves_available = mission_data.get_moves_available()
	
	#Pathfinding.
