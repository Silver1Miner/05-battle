extends Node

signal AI_decision(action, action_position)
# action: attack, switch, item, surrender
# attack_position: which attack, which switch, etc.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func make_decision() -> void:
	emit_signal("AI_decision", 0, 0)
