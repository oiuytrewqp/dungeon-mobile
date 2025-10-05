extends TextureRect

@onready var main_dialog = %MainDialog
@onready var continue_dialog = %ContinueDialog
@onready var new_dialog = %NewDialog
@onready var settings_dialog = %SettingsDialog
@onready var continue_button = %ContinueButton
@onready var quit_button = %QuitButton

@export var show_quit = true

func _ready() -> void:
	quit_button.visible = show_quit
	continue_button.visible = Data.data != null

func show_main_dialog() -> void:
	main_dialog.visible = true
	continue_dialog.visible = false
	new_dialog.visible = false
	settings_dialog.visible = false

func _on_continue_pressed() -> void:
	main_dialog.visible = false
	continue_dialog.visible = true

func _on_new_game_pressed() -> void:
	main_dialog.visible = false
	new_dialog.visible = true

func _on_settings_pressed() -> void:
	main_dialog.visible = false
	settings_dialog.visible = true

func _on_quit_pressed() -> void:
	get_tree().quit()
