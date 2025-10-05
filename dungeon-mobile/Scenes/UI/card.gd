extends PanelContainer

signal card_selected(card)

var card

func _on_button_pressed() -> void:
	card_selected.emit(card)
