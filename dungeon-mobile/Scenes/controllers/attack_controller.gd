extends Node3D

func _ready() -> void:
	var mission_data = Game.get_current_mission()
	mission_data.selected_card_updated.connect(_show_attack_locations)
	mission_data.character_location_updated.connect(_show_attack_locations)
	mission_data.character_attack.connect(_character_attack)

func _clear():
	for child in get_children():
		child.queue_free()

func _show_attack_locations():
	_clear()
	
	var mission_data = Game.get_current_mission()
	var character_location = mission_data.get_character_location()
	
	var adjacent_locations = Pathfinding.neighbours(character_location)
	
	var attack_locations = []
	for adjacent_location in adjacent_locations:
		if mission_data.enemy_at_location(adjacent_location):
			attack_locations.append(adjacent_location)
	
	for attack_location in attack_locations:
		var new_attack = load("res://scenes/attack_cell.tscn").instantiate()
		new_attack.location = attack_location
		add_child(new_attack)

func _character_attack(_enemy, _attack):
	_clear()
