extends Node

var player_action := [0, 0]
# action (attack, switch, item), choice (which attack/switch/item)
var AI_action := [0, 0]

var player_team := {
	0: {},
	1: {},
	2: {}
}
var player_current_active := 0
var ai_team := {
	0: {},
	1: {},
	2: {}
}
var ai_current_active := 0

func _ready() -> void:
	pass

func execute_actions() -> void:
	if player_action[0] == 1: # switch
		player_current_active = player_action[1]
	if AI_action[0] == 1:
		ai_current_active = AI_action[1]

