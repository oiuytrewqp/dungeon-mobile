extends PanelContainer

@onready var name_label = %NameLabel
@onready var move_label = %MoveLabel
@onready var attack_label = %AttackLabel
@onready var actions_container = %ActionsContainer

func _ready() -> void:
	_update_all()
	var current_mission = Game.get_current_mission()
	current_mission.selected_card_updated.connect(_update_all)
	current_mission.character_attack.connect(_hide)
	current_mission.moves_available_updated.connect(_update_moves_available)

func _hide():
	visible = false

func _update_all():
	var mission_data = Game.get_current_mission()
	var selected_card_name = mission_data.get_selected_card_name()
	visible = selected_card_name != null
	if selected_card_name == null:
		return
	
	var selected_card_data = Config.cards[selected_card_name]
	name_label.text = selected_card_data.name
	move_label.text = "Move: %s" %mission_data.get_moves_available()
	attack_label.text = "Atack: %s" %selected_card_data.attack
	
	for action in selected_card_data.actions:
		var new_label = Label.new()
		new_label.text = _format_action(action)
		actions_container.add_child(new_label)

func _update_moves_available():
	var mission_data = Game.get_current_mission()
	move_label.text = "Move: %s" %mission_data.get_moves_available()

func _format_action(action):
	match action.type:
		"attack":
			var distance = "Melee" if action.range == 0 else "Range"
			return "%s attack (%s) %s target(s)" %[distance, action.damage, action.targets]
		"defence":
			return "Defence (%s)" %action.defence
		"invisible":
			return "Invisible"

func _choose_action() -> void:
	pass # Replace with function body.
