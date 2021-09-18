extends Control

signal player_decision(action, choice)

onready var status = $VBoxContainer/status_plane
onready var command = $VBoxContainer/command_plane


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if command.connect("player_choice", self, "_on_player_choice") != OK:
		push_error("player choice signal connect fail")

func _on_player_choice(action, choice) -> void:
	match action:
		0: # yield
			print("Chose to surrender")
			emit_signal("player_decision", action, choice)
		1: # attack
			print("Chose attack number ", choice)
			emit_signal("player_decision", action, choice)
		2: # switch
			print("Chose to switch to ", choice)
			emit_signal("player_decision", action, choice)
