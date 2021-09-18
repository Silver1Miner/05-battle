extends Control

onready var player = $player_controller
onready var AI = $AI
onready var battle_calculator = $battle_calculator
var player_moved := false
var AI_moved := false

enum BATTLE_PHASE {
	BEGIN, # wait for match to begin
	DECISION, # wait for player commands
	COMBAT, # execute commands
	END, # end battle
}
var current_phase = BATTLE_PHASE.DECISION

func _ready() -> void:
	_connect_signals()
	_handle_phase(BATTLE_PHASE.BEGIN)

func _connect_signals() -> void:
	if player.connect("player_decision", self, "_on_player_decision") != OK:
		push_error("player signal connect fail")
	if AI.connect("AI_decision", self, "_on_AI_decision") != OK:
		push_error("AI signal connect fail")

func _handle_phase(new_phase) -> void:
	current_phase = new_phase
	match current_phase:
		BATTLE_PHASE.BEGIN:
			pass # load in data, begin battle
		BATTLE_PHASE.DECISION:
			player_moved = false
			AI_moved = false
		BATTLE_PHASE.COMBAT:
			_execute_combat() # play combat animation
		BATTLE_PHASE.END:
			pass # go to win or lose animation

func _on_player_decision(action, choice) -> void:
	battle_calculator.player_action[0] = action
	battle_calculator.player_action[1] = choice
	match action:
		0: # attack
			print("player chose attack: ", choice)
		1: # switch
			print("player chose switch: ", choice)
		2: # item
			print("player chose item: ", choice)
		3: # surrender
			print("player surrendered: ", choice)
			_handle_phase(BATTLE_PHASE.END)
			return
	player_moved = true
	if AI_moved:
		_handle_phase(BATTLE_PHASE.COMBAT)

func _on_AI_decision(action, choice) -> void:
	battle_calculator.AI_action[0] = action
	battle_calculator.AI_action[1] = choice
	match action:
		0: # attack
			print("AI chose attack: ", choice)
		1: # switch
			print("AI chose switch: ", choice)
		2: # item
			print("AI chose item: ", choice)
		3: # surrender
			print("AI surrendered: ", choice)
			_handle_phase(BATTLE_PHASE.END)
			return
	AI_moved = true
	if player_moved:
		_handle_phase(BATTLE_PHASE.COMBAT)

func _execute_combat() -> void:
	print("player chose action ", battle_calculator.player_action[0], " with choice ", battle_calculator.player_action[1])
	print("AI chose action ", battle_calculator.AI_action[0], " with choice ", battle_calculator.AI_action[1])

# DEBUGGING
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		print("play")
		$team1/actor.play_animation_enter()
		yield($team1/actor.animation_player, "animation_finished")
		$team1/actor.play_animation_fire_primary()
		yield($team1/actor.animation_player, "animation_finished")
		$team1/actor.play_animation_fire_secondary()
		yield($team1/actor.animation_player, "animation_finished")
		$team1/actor.play_animation_exit()
		yield($team1/actor.animation_player, "animation_finished")
		$team2/actor.play_animation_enter()
		yield($team2/actor.animation_player, "animation_finished")
		$team2/actor.play_animation_fire_primary()
		yield($team2/actor.animation_player, "animation_finished")
		$team2/actor.play_animation_fire_secondary()
		yield($team2/actor.animation_player, "animation_finished")
		$team2/actor.play_animation_exit()
		yield($team2/actor.animation_player, "animation_finished")
