extends Control

enum BATTLE_STATES {
	PLAYER, # player 1 turn
	ENEMY, # player 2 (or AI enemy) turn
	WIN, # player 1 wins
	LOSE, # player 2 wins
}
var current_state = BATTLE_STATES.PLAYER

func _ready() -> void:
	_handle_states(BATTLE_STATES.PLAYER)

func _handle_states(new_state) -> void:
	current_state = new_state
	match current_state:
		BATTLE_STATES.PLAYER:
			pass
		BATTLE_STATES.ENEMY:
			pass
		BATTLE_STATES.WIN:
			pass
		BATTLE_STATES.LOSE:
			pass

func _handle_player_turn() -> void:
	pass
