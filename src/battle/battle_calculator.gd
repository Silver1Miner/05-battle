extends Node

var player_action := [0, 0]
# action (attack, switch, item), choice (which attack/switch/item)
var AI_action := [0, 0]

var player_battle_team = [0, 0, 0]
var player_battler_index = -1
var player_items = [0, 0, 0]
var ai_battle_team = [0, 0, 0]
var ai_battler = -1
var ai_items = [0, 0, 0]

func _ready() -> void:
	pass

