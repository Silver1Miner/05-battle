extends Node2D
class_name Battler

signal died
var is_alive := true
export var target_group := "infantry"
var max_hp := 10
var max_health := 100.0
var hp := 10
var health := 100.0
var max_ammo := 9
var ammo := 9

func _ready() -> void:
	pass # Replace with function body.

func set_health(new_value) -> void:
	health = clamp(new_value, 0, max_health)
	if health == 0:
		emit_signal("died")
