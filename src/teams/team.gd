extends Node2D

signal animation_finished

onready var current_unit = 0 # 0, 1, 2
onready var actor := $actor
var current_active := false
onready var remaining_units := 3
var attack_modifier = 0
var defense_modifier = 0
var speed_modifier = 0

var units := [
{
	"name": "Red Rocket Man",
	"skin": "res://assets/battlers/antitank/antitank-red-Sheet.png",
	"status": "OK",
	"type": "red",
	"hp": 20,
	"max_hp": 24,
	"attack": 10,
	"defense": 10,
	"speed": 10,
	"moves": ["Flame Cannon", "Pepper Spray", "Flare Speed"],
	"pp": [10, 10, 10]
},
{
	"name": "Blu Tankie",
	"skin": "res://assets/battlers/tank/tank-blu-Sheet.png",
	"status": "OK",
	"type": "blu",
	"hp": 22,
	"max_hp": 30,
	"attack": 10,
	"defense": 10,
	"speed": 10,
	"moves": ["Hydro Blast", "Gun Harass", "Pump Up"],
	"pp": [10, 10, 10]
}
,{
	"name": "Ylw Cannon",
	"skin": "res://assets/battlers/artillery/artillery-ylw-Sheet.png",
	"status": "OK",
	"type": "ylw",
	"hp": 20,
	"max_hp": 20,
	"attack": 10,
	"defense": 10,
	"speed": 10,
	"moves": ["Mud Blast", "Grape Shot", "Angle Aim"],
	"pp": [10, 10, 10]
}]

func load_in_team(new_team) -> void:
	units = new_team

func get_team_names() -> Array:
	return [units[0]["name"], units[1]["name"], units[2]["name"]]

func get_team_status() -> Array:
	return [units[0]["status"],units[1]["status"],units[2]["status"]]

func get_unit_name() -> String:
	return units[current_unit]["name"]

func get_unit_status() -> String:
	return units[current_unit]["status"]

func get_unit_moves() -> Array:
	return units[current_unit]["moves"]

func get_unit_hp_values() -> Vector2:
	return Vector2(units[current_unit]["hp"], units[current_unit]["max_hp"])

func get_unit_type() -> String:
	return units[current_unit]["type"]

func get_unit_attack() -> float:
	return units[current_unit]["attack"]

func get_unit_defense() -> float:
	return units[current_unit]["defense"]

func get_unit_speed() -> float:
	return units[current_unit]["speed"]

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
	attack_modifier = 0
	defense_modifier = 0
	speed_modifier = 0

func attack(choice: int) -> void:
	#if units[current_unit]["pp"][choice] <= 0:
	#	print("unit is out of pp")
	#	return
	#units[current_unit]["pp"][choice] -= 1
	match choice:
		0:
			actor.play_animation_fire_primary()
		1:
			actor.play_animation_fire_secondary()
		2:
			actor.play_animation_fire_tertiary()
	yield(actor.animation_player, "animation_finished")
	emit_signal("animation_finished")

func take_damage(value: float) -> void:
	var old_hp = units[current_unit]["hp"]
	var new_value = int(clamp(old_hp - round(value), 0, units[current_unit]["max_hp"]))
	units[current_unit]["hp"] = new_value
	if new_value == 0:
		units[current_unit]["status"] = "Fainted"
		remaining_units -= 1
		actor.play_destruction_animation()
		yield(actor.animation_player, "animation_finished")
		current_active = false
	elif new_value < old_hp:
		actor.play_damage_animation()
		yield(actor.animation_player, "animation_finished")
	emit_signal("animation_finished")
