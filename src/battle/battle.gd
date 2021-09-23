extends Control

onready var interface = $interface
onready var command = $interface/VBoxContainer/command_plane
onready var display = $interface/VBoxContainer/status_plane
onready var player_blocker = $interface/VBoxContainer/command_plane/player_side/status/blocker
onready var enemy_blocker = $interface/VBoxContainer/command_plane/enemy_side/options/blocker
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
	REINFORCE, # replace defeated units
	WIN, # end battle in victory
	LOSE # end battle in defeat
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
			player_blocker.visible = false
			enemy_blocker.visible = false
			player_moved = false
			AI_moved = false
		BATTLE_PHASE.COMBAT:
			_execute_combat() # play combat animation
		BATTLE_PHASE.REINFORCE:
			_choose_replacements()
		BATTLE_PHASE.WIN:
			print("won battle")
		BATTLE_PHASE.LOSE:
			print("lost battle")
			pass # go to win or lose animation

func _play_intro_phase() -> void:
	command.update_switch_choices(team1.get_team_names(), team1.get_team_status(), 0)
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
	player_blocker.visible = false
	enemy_blocker.visible = false

func _on_player_decision(action, choice) -> void:
	# TODO: add validity check
	player_choice[0] = action
	player_choice[1] = choice
	if action == 0: # yield
		_handle_phase(BATTLE_PHASE.END)
		return
	player_moved = true
	#if AI_moved:
	#	_handle_phase(BATTLE_PHASE.COMBAT)
	player_blocker.visible = true
	AI_choice[0] = 1
	AI_choice[1] = 2
	enemy_blocker.visible = true
	_handle_phase(BATTLE_PHASE.COMBAT) # debugging

func _on_AI_decision(action, choice) -> void:
	AI_choice[0] = action
	AI_choice[1] = choice
	AI_moved = true
	if player_moved:
		_handle_phase(BATTLE_PHASE.COMBAT)

func _execute_combat() -> void:
	# TODO: implement priority checks and AI side
	command.set_switch_only(false)
	if player_choice[0] == 2: # switch
		if player_choice[1] != team1.current_unit and team1.units[player_choice[1]]["status"] != "Fainted":
			team1.switch_units(player_choice[1])
			command.update_player_text_feed("Go " + team1.get_unit_name() + "!")
			command.update_enemy_text_feed("")
			display.update_player_all(
				team1.get_unit_name(),
				team1.get_unit_status(),
				team1.get_unit_hp_values()
			)
			command.update_attack_choices(team1.get_unit_moves())
			yield(team1, "animation_finished")
		if team2.current_active:
			team2.attack(AI_choice[1])
			command.update_enemy_text_feed(team2.get_unit_name() + " used " + team2.get_unit_moves()[AI_choice[1]] + "!")
			yield(team2, "animation_finished")
			team1.take_damage(5)
			command.update_player_text_feed(team1.get_unit_name() + " took " + str(5) + " damage!")
			display.update_player_all(
				team1.get_unit_name(),
				team1.get_unit_status(),
				team1.get_unit_hp_values())
			yield(team1, "animation_finished")
			yield(get_tree().create_timer(1.0), "timeout")
			if !team1.current_active:
				command.update_player_text_feed(team1.get_unit_name() + " was defeated!")
				_handle_phase(BATTLE_PHASE.REINFORCE)
				return
	elif player_choice[0] == 1: # attack
		command.update_player_text_feed(team1.get_unit_name() + " used " + team1.get_unit_moves()[player_choice[1]] + "!")
		team1.attack(player_choice[1])
		yield(team1, "animation_finished")
		var power = 120
		var a = 10
		var d = 10
		var stab = 1
		var type = 1
		var battle_damage = battle_calculator.calculate_damage(power, a, d, stab, type)
		team2.take_damage(battle_damage)
		command.update_enemy_text_feed(team2.get_unit_name() + " took " + str(round(battle_damage)) + " damage!")
		#print("team 2 has ", team2.get_unit_hp_values(), " hp")
		display.update_enemy_all(
				team2.get_unit_name(),
				team2.get_unit_status(),
				team2.get_unit_hp_values())
		yield(team2, "animation_finished")
		yield(get_tree().create_timer(1.0), "timeout")
		if team2.current_active:
			team2.attack(AI_choice[1])
			command.update_enemy_text_feed(team2.get_unit_name() + " used " + team2.get_unit_moves()[AI_choice[1]] + "!")
			yield(team2, "animation_finished")
			team1.take_damage(battle_damage)
			command.update_player_text_feed(team1.get_unit_name() + " took " + str(round(battle_damage)) + " damage!")
			display.update_player_all(
				team1.get_unit_name(),
				team1.get_unit_status(),
				team1.get_unit_hp_values())
			yield(team1, "animation_finished")
			yield(get_tree().create_timer(1.0), "timeout")
			if !team1.current_active:
				command.update_player_text_feed(team1.get_unit_name() + " was defeated!")
				_handle_phase(BATTLE_PHASE.REINFORCE)
				return
		else:
			command.update_enemy_text_feed(team2.get_unit_name() + " was defeated!")
			yield(get_tree().create_timer(1.5), "timeout")
			_handle_phase(BATTLE_PHASE.REINFORCE)
			return
		command.update_player_text_feed("")
		command.update_enemy_text_feed("")
	command.update_switch_choices(team1.get_team_names(), team1.get_team_status(), team1.current_unit)
	_handle_phase(BATTLE_PHASE.DECISION)

func _choose_replacements() -> void:
	if team1.remaining_units == 0:
		 _handle_phase(BATTLE_PHASE.LOSE)
	if team1.current_active:
		pass
	else:
		player_blocker.visible = false
		command.set_switch_only(true)
	if team2.remaining_units == 0:
		command.update_enemy_text_feed("There are no remaining battlers!")
		yield(get_tree().create_timer(1.5), "timeout")
		_handle_phase(BATTLE_PHASE.WIN)
	if team2.current_active:
		pass
	else:
		for i in 3:
			if team2.units[i]["status"] != "Fainted":
				team2.switch_units(i)
				command.update_player_text_feed("")
				command.update_enemy_text_feed("Enemy sent out " + team2.get_unit_name() + "!")
				display.update_enemy_all(
				team2.get_unit_name(),
				team2.get_unit_status(),
				team2.get_unit_hp_values())
				_handle_phase(BATTLE_PHASE.DECISION)
				return
