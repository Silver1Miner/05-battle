extends Control

onready var interface = $interface
onready var command = $interface/VBoxContainer/command_plane
onready var display = $interface/VBoxContainer/status_plane
onready var command_blocker = $interface/VBoxContainer/command_plane/player_side/status/blocker
onready var AI = $AI
onready var battle_calculator = $battle_calculator
var player_moved := false
var AI_moved := false
onready var team1 = $team1
onready var team2 = $team2
var player_choice = [0, 0] # action, choice
var AI_choice = [0, 0]

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
	if command.connect("player_choice", self, "_on_player_decision") != OK:
		push_error("player signal connect fail")
	if AI.connect("AI_decision", self, "_on_AI_decision") != OK:
		push_error("AI signal connect fail")

func _handle_phase(new_phase) -> void:
	current_phase = new_phase
	match current_phase:
		BATTLE_PHASE.BEGIN:
			_play_intro_phase()
		BATTLE_PHASE.DECISION:
			command_blocker.visible = false
			player_moved = false
			AI_moved = false
		BATTLE_PHASE.COMBAT:
			_execute_combat() # play combat animation
		BATTLE_PHASE.END:
			print("battle ended")
			pass # go to win or lose animation

func _play_intro_phase() -> void:
	command.update_switch_choices(team1.get_team_names())
	command.update_attack_choices(team1.get_unit_moves())
	display.update_player_name(team1.get_unit_name())
	team1.play_intro()
	yield(team1, "animation_finished")
	display.update_player_status(team1.get_unit_status())
	display.update_player_hp(team1.get_unit_hp_values())
	display.update_enemy_name(team2.get_unit_name())
	team2.play_intro()
	yield(team2, "animation_finished")
	display.update_enemy_status(team2.get_unit_status())
	display.update_enemy_hp(team2.get_unit_hp_values())
	command_blocker.visible = false

func _on_player_decision(action, choice) -> void:
	# TODO: add validity check
	player_choice[0] = action
	player_choice[1] = choice
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
	#if AI_moved:
	#	_handle_phase(BATTLE_PHASE.COMBAT)
	command_blocker.visible = true
	_handle_phase(BATTLE_PHASE.COMBAT) # debugging

func _on_AI_decision(action, choice) -> void:
	AI_choice[0] = action
	AI_choice[1] = choice
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
	# TODO: implement priority checks and AI side
	if player_choice[0] == 2: # switch
		if player_choice[1] != team1.current_unit and team1.units[player_choice[1]]["status"] != "Fainted":
			team1.switch_units(player_choice[1])
			display.update_player_all(
				team1.get_unit_name(),
				team1.get_unit_status(),
				team1.get_unit_hp_values()
			)
			command.update_attack_choices(team1.get_unit_moves())
			yield(team1, "animation_finished")
	elif player_choice[0] == 1: # attack
		team1.attack(player_choice[1])
		yield(team1, "animation_finished")
	_handle_phase(BATTLE_PHASE.DECISION)
