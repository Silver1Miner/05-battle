extends Node2D

signal animation_finished

onready var current_unit = 0 # 0, 1, 2
onready var actor := $actor
var current_active := false

var units := [
{
	"skin": "res://assets/battlers/antitank/antitank-red-Sheet.png",
	"hp": 20,
	"max_hp": 22,
	"attack": 10,
	"defense": 10,
	"speed": 10,
	"moves": [0, 0, 0, 0],
	"pp": [10, 10, 10, 10]
},
{
	"skin": "res://assets/battlers/tank/tank-blu-Sheet.png",
	"hp": 20,
	"max_hp": 22,
	"attack": 10,
	"defense": 10,
	"speed": 10,
	"moves": [0, 0, 0, 0],
	"pp": [10, 10, 10, 10]
}
,{
	"skin": "res://assets/battlers/artillery/artillery-ylw-Sheet.png",
	"hp": 20,
	"max_hp": 22,
	"attack": 10,
	"defense": 10,
	"speed": 10,
	"moves": [0, 0, 0, 0],
	"pp": [10, 10, 10, 10]
}]

func play_intro() -> void:
	current_active = true
	actor.load_new_skin(units[0]["skin"])
	actor.play_animation_enter()
	yield(actor.animation_player, "animation_finished")
	emit_signal("animation_finished")

func switch_units(choice: int) -> void:
	current_unit = choice
	if current_active:
		actor.play_animation_exit()
		yield(actor.animation_player, "animation_finished")
	actor.load_new_skin(units[choice]["skin"])
	actor.play_animation_enter()
	yield(actor.animation_player, "animation_finished")
	emit_signal("animation_finished")
	current_active = true

func attack(choice: int, style: int) -> void:
	if units[current_unit]["pp"][choice] <= 0:
		print("unit is out of pp")
		return
	units[current_unit]["pp"][choice] -= 1
	match style:
		0:
			actor.play_animation_fire_primary()
		1:
			actor.play_animation_fire_secondary()
	yield(actor.animation_player, "animation_finished")
	emit_signal("animation_finished")

func take_damage(value) -> void:
	var old_hp = units[current_unit]["hp"]
	var new_value = int(clamp(0, units[current_unit]["max_hp"], old_hp - value))
	if new_value == 0:
		actor.play_destruction_animation()
		yield(actor.animation_player, "animation_finished")
		current_active = false
	elif new_value < old_hp:
		actor.play_damage_animation()
		yield(actor.animation_player, "animation_finished")
	emit_signal("animation_finished")
