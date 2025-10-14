extends TextureRect

@onready var continue_button = %ContinueButton
@onready var quit_button = %QuitButton

@export var show_quit = true

func _ready() -> void:
	quit_button.visible = show_quit
	continue_button.visible = Game.save_game_loaded()

func _on_continue_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/dialogs/continue_dialog.tscn")

func _on_new_game_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/dialogs/new_dialog.tscn")

func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/dialogs/settings_dialog.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
