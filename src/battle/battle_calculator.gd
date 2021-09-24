extends Node

func calculate_stab(user_type, move_type) -> float:
	if user_type == move_type:
		return 1.5
	return 1.0

# 0 red, 1 yellow, 2 purple, 3 blue, 4 green
var type_matcher := [
	[1.0, 0.5, 2.0, 1.0, 1.0],
	[1.0, 1.0, 0.5, 2.0, 1.0],
	[1.0, 1.0, 1.0, 0.5, 2.0],
	[2.0, 1.0, 1.0, 1.0, 0.5],
	[0.5, 2.0, 1.0, 1.0, 1.0]
]
var type_conversion := {
	"red": 0, "ylw": 1, "prp": 2, "blu": 3, "grn": 4
}
func calculate_type(a_type, d_type) -> float:
	return type_matcher[type_conversion[a_type]][type_conversion[d_type]]

func calculate_damage(power, a, d, stab, type) -> float:
	var base_damage = (4.0 * power * (a/d))/50.0 + 2.0
	return base_damage * stab * type

func accuracy_check(move_accuracy) -> bool:
	randomize()
	var roll = rand_range(0, 100)
	return roll <= move_accuracy
