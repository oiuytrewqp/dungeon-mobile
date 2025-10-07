extends Control

var MISSION_CONTAINER = preload("res://scenes/ui/mission_container.tscn")

@onready var missions_container = %MissionsContainer

@onready var name_label = %NameLabel
@onready var description_label = %DescriptionLabel
@onready var objective_label = %ObjectiveLabel
@onready var enemies_label = %EnemiesLabel

var selected_mission

func _ready() -> void:
	update_missions()

func update_missions():
	var missions = Data.data.next_missions
	
	_mission_selected(missions[0])
	
	for mission in missions:
		var new_mission_container = MISSION_CONTAINER.instantiate()
		new_mission_container.mission = mission
		new_mission_container.selected.connect(_mission_selected)
		missions_container.add_child(new_mission_container)

func _mission_selected(mission):
	selected_mission = mission
	
	var mission_data = Config.missions[mission]
	
	name_label.text = "Name: %s" %mission_data.name
	description_label.text = "Description: %s" %mission_data.description
	objective_label.text = "Objective: %s" %mission_data.objective
	enemies_label.text = "Enemies: %s" %mission_data.enemies

func _on_go_pressed() -> void:
	Data.data.current_mission = selected_mission
	
	Data.save()
	
	get_tree().change_scene_to_file("res://scenes/mission.tscn")
