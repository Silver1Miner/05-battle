extends Node
# Player data

var current_opponent := 0
var player_team := [
{
	"name": "Red Rocket Man",
	"skin": "res://assets/battlers/antitank/antitank-red-Sheet.png",
	"status": "OK",
	"type": "red",
	"hp": 24,
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
	"hp": 30,
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
