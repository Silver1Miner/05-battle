extends Control

onready var interface = $interface
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
	if interface.connect("player_decision", self, "_on_player_decision") != OK:
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
	match action:
		0: # yield
			print("player surrendered: ", choice)
			_handle_phase(BATTLE_PHASE.END)
			return
		1: # attack
			print("player chose attack: ", choice)
		2: # switch
			print("player chose switch: ", choice)
	player_moved = true
	if AI_moved:
		_handle_phase(BATTLE_PHASE.COMBAT)

func _on_AI_decision(action, choice) -> void:
	match action:
		0: # yield
			print("AI surrendered: ", choice)
			_handle_phase(BATTLE_PHASE.END)
			return
		1: # attack
			print("AI chose switch: ", choice)
		2: # switch
			print("AI chose item: ", choice)
	AI_moved = true
	if player_moved:
		_handle_phase(BATTLE_PHASE.COMBAT)

func _execute_combat() -> void:
	pass

# DEBUGGING
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_home"):
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
