extends Node

func calculate_stab(user, move) -> float:
	if user == move:
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
func calculate_type(attacker, defender) -> float:
	return type_matcher[attacker][defender]

func calculate_damage(power, a, d, stab, type) -> float:
	var base_damage = (4.0 * power * (a/d))/50.0 + 2.0
	return base_damage * stab * type
