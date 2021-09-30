extends Node
# Player data

var unlocked_battles := [1, 0, 0, 0, 0]
var battle_menu_on := false
var current_opponent := 0
var backgrounds := {
	0: "res://assets/bg/battleback3.png",
	1: "res://assets/bg/battleback1.png",
	2: "res://assets/bg/battleback6.png",
	3: "res://assets/bg/battleback8.png",
	4: "res://assets/bg/battleback10.png"
}
var player_team := [
{},
{}
,{}]

func _ready():
	load_state()

func reset() -> void:
	unlocked_battles = [1, 0, 0, 0, 0]
	save_state()

func load_state() -> void:
	var save_game = File.new()
	if not save_game.file_exists("user://battleranger.save"):
		return # Error! We don't have a save to load.
	save_game.open("user://battleranger.save", File.READ)
	unlocked_battles = parse_json(save_game.get_line())
	save_game.close()

func save_state() -> void:
	var save_game = File.new()
	save_game.open("user://battleranger.save", File.WRITE)
	save_game.store_line(to_json(unlocked_battles))
	save_game.close()
