extends Control

@onready var profile_button = %ProfileButton
@onready var items_button = %ItemsButton
@onready var cards_button = %CardsButton
@onready var missions_button = %MissionsButton

@onready var profile_panel = %ProfilePanel
@onready var items_panel = %ItemsPanel
@onready var cards_panel = %CardsPanel
@onready var missions_panel = %MissionsPanel

func _on_profile_pressed() -> void:
	items_button.button_pressed = false
	cards_button.button_pressed = false
	missions_button.button_pressed = false
	
	profile_panel.visible = true
	items_panel.visible = false
	cards_panel.visible = false
	missions_panel.visible = false
	GameState.set_state(GameState.State.MAIN_MENU)

func _on_items_pressed() -> void:
	profile_button.button_pressed = false
	cards_button.button_pressed = false
	missions_button.button_pressed = false
	
	profile_panel.visible = false
	items_panel.visible = true
	cards_panel.visible = false
	missions_panel.visible = false
	GameState.set_state(GameState.State.MAIN_MENU)

func _on_cards_pressed() -> void:
	profile_button.button_pressed = false
	items_button.button_pressed = false
	missions_button.button_pressed = false
	
	profile_panel.visible = false
	items_panel.visible = false
	cards_panel.visible = true
	missions_panel.visible = false
	GameState.set_state(GameState.State.MAIN_MENU)

func _on_missions_pressed() -> void:
	profile_button.button_pressed = false
	items_button.button_pressed = false
	cards_button.button_pressed = false
	
	profile_panel.visible = false
	items_panel.visible = false
	cards_panel.visible = false
	missions_panel.visible = true
	GameState.set_state(GameState.State.MISSION_SELECT)
