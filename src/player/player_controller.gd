extends Node
# Player: handles intake command functions

enum SELECT_MODES {
	SELECT,
	ATTACK, # ui_accept
	SWITCH, # ui_cancel
	ITEM, # ui_select
	SURRENDER # ui_home
}
signal player_decision(action, choice)
# action: attack, switch, item, surrender
# choice: which attack, which switch, etc.

var current_mode = SELECT_MODES.SELECT
var current_select_index := 0

func _ready() -> void:
	_handle_selection(SELECT_MODES.SELECT)

func _handle_selection(new_mode) -> void:
	current_mode = new_mode
	match current_mode:
		SELECT_MODES.SELECT:
			pass
		SELECT_MODES.ATTACK:
			pass
		SELECT_MODES.SWITCH:
			pass
		SELECT_MODES.ITEM:
			pass
		SELECT_MODES.SURRENDER:
			pass

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		match current_mode:
			SELECT_MODES.SELECT:
				_handle_selection(SELECT_MODES.ATTACK)
			SELECT_MODES.ATTACK:
				emit_signal("player_decision", 0, current_select_index)
			SELECT_MODES.SWITCH:
				emit_signal("player_decision", 1, current_select_index)
			SELECT_MODES.ITEM:
				emit_signal("player_decision", 2, current_select_index)
			SELECT_MODES.SURRENDER:
				emit_signal("player_decision", 3, 0)
	elif event.is_action_pressed("ui_cancel"):
		match current_mode:
			SELECT_MODES.SELECT:
				_handle_selection(SELECT_MODES.SWITCH)
			SELECT_MODES.ATTACK:
				_handle_selection(SELECT_MODES.SELECT)
			SELECT_MODES.SWITCH:
				_handle_selection(SELECT_MODES.SELECT)
			SELECT_MODES.SURRENDER:
				_handle_selection(SELECT_MODES.SELECT)
