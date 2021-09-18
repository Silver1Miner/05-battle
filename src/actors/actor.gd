extends Node2D
class_name Actor

onready var animation_player = $AnimationPlayer
onready var sprite = $Sprite

func load_new_skin(new_skin_path) -> void:
	sprite.texture = load(new_skin_path)

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

func play_animation_fire_tertiary() -> void:
	animation_player.play("fire_tertiary")
