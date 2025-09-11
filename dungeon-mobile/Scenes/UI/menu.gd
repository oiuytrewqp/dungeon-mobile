extends Control

func _on_continue_pressed():
	# Load the saved game
	print("Continue button pressed")
	# Add your continue game logic here
	# For example: get_tree().change_scene_to_file("res://path_to_your_game_scene.tscn")

func _on_new_game_pressed():
	# Start a new game
	print("New Game button pressed")
	# Add your new game logic here
	# For example: get_tree().change_scene_to_file("res://path_to_your_game_scene.tscn")

func _on_settings_pressed():
	# Open settings menu
	print("Settings button pressed")
	# Add your settings menu logic here

func _on_quit_pressed():
	# Quit the game
	print("Quit button pressed")
	get_tree().quit()
