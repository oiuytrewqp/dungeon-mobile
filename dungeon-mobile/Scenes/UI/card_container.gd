extends PanelContainer

@onready var name_label = %NameLabel
@onready var move_label = %MoveLabel
@onready var attack_label = %AttackLabel
@onready var actions_container = %ActionsContainer

func _ready() -> void:
	_update()
	Data.playing_updated.connect(_update)

func _update():
	var playing_card = Data.data.character.playing
	visible = playing_card != null
	if playing_card == null:
		return
	
	var card_data = Config.cards[Data.data.character.playing.card]
	name_label.text = card_data.name
	move_label.text = "Move: %s" %card_data.move
	attack_label.text = "Atack: %s" %card_data.attack
	
	for action in card_data.actions:
		var new_label = Label.new()
		new_label.text = _format_action(action)
		actions_container.add_child(new_label)

func _format_action(action):
	match action.type:
		"attack":
			var distance = "Melee" if action.range == 0 else "Range"
			return "%s attack (%s) %s target(s)" %[distance, action.damage, action.targets]
		"defence":
			return "Defence (%s)" %action.defence
		"invisible":
			return "Invisible"

func _choose_attack() -> void:
	pass # Replace with function body.

func _choose_action() -> void:
	pass # Replace with function body.
