extends Node

enum State {
	MAIN_MENU,
	MISSION_SELECT,
	IN_MISSION,
	GAME_OVER,
	MISSION_COMPLETE
}

var current_state = State.MAIN_MENU
signal state_changed(new_state)

func set_state(new_state: State):
	if current_state == new_state:
		return
	
	current_state = new_state
	state_changed.emit(new_state)
