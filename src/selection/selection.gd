extends Control

onready var rental_pool = $VBoxContainer/ItemList
onready var player_team_list = $VBoxContainer/team_display/player_team/ItemList
onready var enemy_team_list = $VBoxContainer/team_display/enemy_team/ItemList
onready var menu_button = $VBoxContainer/HBoxContainer/back
onready var start_button = $VBoxContainer/battle

func _ready() -> void:
	if menu_button.connect("pressed", self, "_on_menu_pressed") != OK:
		push_error("menu button connect fail")
	if start_button.connect("pressed", self, "_on_start_pressed") != OK:
		push_error("start button connect fail")
	populate_rental_list()
	populate_enemy_team()

func _on_menu_pressed() -> void:
	if get_tree().change_scene("res://src/menu/Main.tscn") != OK:
		push_error("fail to return to main menu")

func _on_start_pressed() -> void:
	if get_tree().change_scene("res://src/battle/battle.tscn") != OK:
		push_error("fail to start battle")

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
