extends Node2D
class_name Battler

signal died
enum SIDES {LEFT, RIGHT}
var current_side = SIDES.LEFT

onready var animation_player = $AnimationPlayer

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
	var old_hp = hp
	hp = int(health/10)
	play_damage_animation(old_hp, hp)
	if health == 0:
		emit_signal("died")

func set_ammo(new_value) -> void:
	ammo = int(clamp(new_value, 0, max_ammo))

func set_sprite_to_health() -> void:
	if hp > 8:
		pass
	elif hp > 6:
		$Sprite1.visible = false
	elif hp > 4:
		$Sprite2.visible = false
	elif hp > 2:
		$Sprite3.visible = false
	elif hp > 0:
		$Sprite4.visible = false

func play_damage_animation(_start_hp, _end_hp) -> void:
	pass

func play_animation_enter() -> void:
	animation_player.play("enter_scene")

func play_animation_exit() -> void:
	animation_player.play("exit_scene")

func play_animation_fire_primary() -> void:
	animation_player.play("fire_prim")

func play_animation_fire_secondary() -> void:
	animation_player.play("fire_mg")
