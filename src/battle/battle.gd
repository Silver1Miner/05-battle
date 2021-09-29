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
onready var sounds = $Sounds

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
	$end_state_screen.visible = false
	Music.change_track(1)
	$background.texture = load(PlayerData.backgrounds[PlayerData.current_opponent])
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
			team1.load_in_team(PlayerData.player_team)
			team2.load_in_team(Database.enemy_team[PlayerData.current_opponent])
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
			Music.change_track(0)
			$end_state_screen.visible = true
			$end_state_screen/AnimationPlayer.play("victory")
			yield(get_tree().create_timer(3.0), "timeout")
			PlayerData.battle_menu_on = true
			if get_tree().change_scene("res://src/menu/Main.tscn") != OK:
				push_error("fail to return to main menu")
		BATTLE_PHASE.LOSE:
			Music.change_track(0)
			$end_state_screen.visible = true
			$end_state_screen/AnimationPlayer.play("defeat")
			yield(get_tree().create_timer(3.0), "timeout")
			PlayerData.battle_menu_on = true
			if get_tree().change_scene("res://src/menu/Main.tscn") != OK:
				push_error("fail to return to main menu")

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
		_handle_phase(BATTLE_PHASE.LOSE)
		return
	player_moved = true
	#if AI_moved:
	#	_handle_phase(BATTLE_PHASE.COMBAT)
	player_blocker.visible = true
	randomize()
	AI_choice[0] = 1
	AI_choice[1] = 1
	var decide = rand_range(0, 10)
	if decide < 5:
		AI_choice[1] = 0
	elif decide < 8:
		AI_choice[1] = 1
	else:
		AI_choice[1] = 2
	enemy_blocker.visible = true
	if current_phase == BATTLE_PHASE.REINFORCE:
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
		command.set_switch_only(false)
		_handle_phase(BATTLE_PHASE.DECISION)
	else:
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
			sounds.match_sound(AI_choice[1])
			command.update_enemy_text_feed(team2.get_unit_name() + " used " + team2.get_unit_moves()[AI_choice[1]] + "!")
			yield(team2, "animation_finished")
			var name_2 = team2.get_unit_moves()[AI_choice[1]]
			_enemy_attack_damage_calculation(name_2)
			yield(get_tree().create_timer(1.0), "timeout")
			if !team1.current_active:
				command.update_player_text_feed(team1.get_unit_name() + " was defeated!")
				_handle_phase(BATTLE_PHASE.REINFORCE)
				return
	elif player_choice[0] == 1: # attack
		if team1.get_unit_speed() >= team2.get_unit_speed():
			command.update_player_text_feed(team1.get_unit_name() + " used " + team1.get_unit_moves()[player_choice[1]] + "!")
			team1.attack(player_choice[1])
			sounds.match_sound(player_choice[1])
			yield(team1, "animation_finished")
			var name_move = team1.get_unit_moves()[player_choice[1]]
			_player_attack_damage_calculation(name_move)
			yield(get_tree().create_timer(1.5), "timeout")
			if team2.current_active:
				team2.attack(AI_choice[1])
				sounds.match_sound(AI_choice[1])
				command.update_enemy_text_feed(team2.get_unit_name() + " used " + team2.get_unit_moves()[AI_choice[1]] + "!")
				yield(team2, "animation_finished")
				var enemy_name_move = team2.get_unit_moves()[AI_choice[1]]
				_enemy_attack_damage_calculation(enemy_name_move)
				yield(get_tree().create_timer(1.5), "timeout")
				if !team1.current_active:
					command.update_player_text_feed(team1.get_unit_name() + " was defeated!")
					_handle_phase(BATTLE_PHASE.REINFORCE)
					return
			else:
				command.update_enemy_text_feed(team2.get_unit_name() + " was defeated!")
				yield(get_tree().create_timer(1.5), "timeout")
				_handle_phase(BATTLE_PHASE.REINFORCE)
				return
		else:
			command.update_enemy_text_feed(team2.get_unit_name() + " used " + team2.get_unit_moves()[AI_choice[1]] + "!")
			team2.attack(AI_choice[1])
			sounds.match_sound(AI_choice[1])
			yield(team2, "animation_finished")
			var name_move = team2.get_unit_moves()[AI_choice[1]]
			_enemy_attack_damage_calculation(name_move)
			yield(get_tree().create_timer(1.5), "timeout")
			if team1.current_active:
				team1.attack(player_choice[1])
				sounds.match_sound(player_choice[1])
				command.update_player_text_feed(team1.get_unit_name() + " used " + team1.get_unit_moves()[player_choice[1]] + "!")
				yield(team1, "animation_finished")
				var player_name_move = team2.get_unit_moves()[AI_choice[1]]
				_player_attack_damage_calculation(player_name_move)
				yield(get_tree().create_timer(1.5), "timeout")
				if !team2.current_active:
					command.update_player_text_feed(team2.get_unit_name() + " was defeated!")
					_handle_phase(BATTLE_PHASE.REINFORCE)
					return
			else:
				command.update_enemy_text_feed(team1.get_unit_name() + " was defeated!")
				yield(get_tree().create_timer(1.5), "timeout")
				_handle_phase(BATTLE_PHASE.REINFORCE)
				return
		command.update_player_text_feed("")
		command.update_enemy_text_feed("")
	command.update_switch_choices(team1.get_team_names(), team1.get_team_status(), team1.current_unit)
	_handle_phase(BATTLE_PHASE.DECISION)

func _player_attack_damage_calculation(name_move) -> void:
	var power = 100
	if name_move in Database.movedata:
		power = Database.movedata[name_move]["power"]
	var a = team1.get_unit_attack()
	var d = team2.get_unit_defense()
	var stab = battle_calculator.calculate_stab(team1.get_unit_type(),Database.movedata[name_move]["type"])
	var type = battle_calculator.calculate_type(team1.get_unit_type(), team2.get_unit_type())
	var battle_damage = battle_calculator.calculate_damage(power, a, d, stab, type)
	if battle_calculator.accuracy_check(Database.movedata[name_move]["accuracy"]):
		if "stat" in Database.movedata[name_move]:
			if Database.movedata[name_move]["target"] == "self":
				match "stat":
					"attack":
						team1.attack_modifier = clamp(team1.attack_modifier + Database.movedata[name_move]["effect"],-4,4)
					"defense":
						team1.defense_modifier = clamp(team1.defense_modifier + Database.movedata[name_move]["effect"],-4,4)
					"speed":
						team1.speed_modifier = clamp(team1.speed_modifier + Database.movedata[name_move]["effect"],-4,4)
				command.update_player_text_feed(team1.get_unit_name() + "'s " + Database.movedata[name_move]["stat"] + " rose!")
		else:
			team2.take_damage(battle_damage)
			command.update_enemy_text_feed(team2.get_unit_name() + " took " + str(round(battle_damage)) + " damage!")
			sounds.match_sound(3)
	else:
		command.update_enemy_text_feed("The attack missed!")
	#print("team 2 has ", team2.get_unit_hp_values(), " hp")
	display.update_enemy_all(
		team2.get_unit_name(),
		team2.get_unit_status(),
		team2.get_unit_hp_values())

func _enemy_attack_damage_calculation(name_move) -> void:
	var power = 100
	if name_move in Database.movedata:
		power = Database.movedata[name_move]["power"]
	var a = team2.get_unit_attack()
	var d = team1.get_unit_defense()
	var stab = battle_calculator.calculate_stab(team2.get_unit_type(),Database.movedata[name_move]["type"])
	var type = battle_calculator.calculate_type(team2.get_unit_type(), team1.get_unit_type())
	var battle_damage = battle_calculator.calculate_damage(power, a, d, stab, type)
	if battle_calculator.accuracy_check(Database.movedata[name_move]["accuracy"]):
		if "stat" in Database.movedata[name_move]:
			if Database.movedata[name_move]["target"] == "self":
				match "stat":
					"attack":
						team2.attack_modifier = clamp(team2.attack_modifier + Database.movedata[name_move]["effect"],-4,4)
					"defense":
						team2.defense_modifier = clamp(team2.defense_modifier + Database.movedata[name_move]["effect"],-4,4)
					"speed":
						team2.speed_modifier = clamp(team2.speed_modifier + Database.movedata[name_move]["effect"],-4,4)
			command.update_enemy_text_feed(team2.get_unit_name() + "'s " + Database.movedata[name_move]["stat"] + " rose!")
		else:
			team1.take_damage(battle_damage)
			command.update_player_text_feed(team1.get_unit_name() + " took " + str(round(battle_damage)) + " damage!")
			sounds.match_sound(3)
	else:
		command.update_enemy_text_feed("The attack missed!")
	display.update_player_all(
		team1.get_unit_name(),
		team1.get_unit_status(),
		team1.get_unit_hp_values())

func _choose_replacements() -> void:
	if team1.remaining_units == 0:
		 _handle_phase(BATTLE_PHASE.LOSE)
	if team1.current_active:
		pass
	else:
		command.update_switch_choices(team1.get_team_names(), team1.get_team_status(), team1.current_unit)
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
				enemy_blocker.visible = true
				command.update_player_text_feed("")
				command.update_enemy_text_feed("Enemy sent out " + team2.get_unit_name() + "!")
				display.update_enemy_all(
				team2.get_unit_name(),
				team2.get_unit_status(),
				team2.get_unit_hp_values())
				yield(get_tree().create_timer(1.5), "timeout")
				command.update_enemy_text_feed("")
				enemy_blocker.visible = false
				_handle_phase(BATTLE_PHASE.DECISION)
				return
