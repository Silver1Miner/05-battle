extends Control

onready var rental_pool = $VBoxContainer/ItemList
onready var player_team_list = $VBoxContainer/team_display/player_team/ItemList
onready var enemy_team_list = $VBoxContainer/team_display/enemy_team/ItemList

func _ready() -> void:
	populate_rental_list()
	populate_enemy_team()

func populate_rental_list() -> void:
	rental_pool.set_fixed_column_width(115)
	for i in range(25):
		rental_pool.add_item(Database.rental_pool[i]["name"],
		load(Database.rental_pool[i]["icon"]), true)

func populate_enemy_team() -> void:
	for i in range(3):
		enemy_team_list.add_item(
			Database.enemy_team[PlayerData.current_opponent][i]["name"],
			load(Database.enemy_team[PlayerData.current_opponent][i]["icon"]),
			false)
