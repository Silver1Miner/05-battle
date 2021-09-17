extends Node2D
class_name Actor

export var flip := false
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
	if flip:
		scale.x = -2
	pass # Replace with function body.

func set_health(new_value) -> void:
	health = clamp(new_value, 0, max_health)
	hp = int(health/10)
	play_damage_animation()
	if health == 0:
		emit_signal("died")
		play_destruction_animation()

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

func play_destruction_animation() -> void:
	animation_player.play("destruction")

func play_damage_animation() -> void:
	animation_player.play("take_damage")

func play_animation_enter() -> void:
	animation_player.play("enter_scene")

func play_animation_exit() -> void:
	animation_player.play("exit_scene")

func play_animation_fire_primary() -> void:
	animation_player.play("fire_primary")

func play_animation_fire_secondary() -> void:
	animation_player.play("fire_secondary")
