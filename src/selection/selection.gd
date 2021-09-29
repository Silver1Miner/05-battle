extends Control

onready var rental_pool = $VBoxContainer/ItemList
onready var player_team_list = $VBoxContainer/team_display/player_team/ItemList
onready var enemy_team_list = $VBoxContainer/team_display/enemy_team/ItemList
onready var menu_button = $VBoxContainer/HBoxContainer/back
onready var start_button = $VBoxContainer/battle
onready var reset_button = $VBoxContainer/HBoxContainer/reset

func _ready() -> void:
	if menu_button.connect("pressed", self, "_on_menu_pressed") != OK:
		push_error("menu button connect fail")
	if start_button.connect("pressed", self, "_on_start_pressed") != OK:
		push_error("start button connect fail")
	if reset_button.connect("pressed", self, "_on_reset_pressed") != OK:
		push_error("reset button connect fail")
	if rental_pool.connect("item_selected", self, "_on_item_selected") != OK:
		push_error("select connect fail")
	populate_rental_list()
	populate_enemy_team()
	start_button.disabled = true

func _on_item_selected(index: int) -> void:
	if player_team_list.get_item_count() < 3:
		player_team_list.add_item(
				Database.rental_pool[index]["name"],
				load(Database.rental_pool[index]["icon"]),
				false)
		player_team_list.set_item_tooltip(player_team_list.get_item_count()-1, """%s
Attack: %s
Defense: %s
Speed: %s
Moves: %s
		"""
% [Database.rental_pool[index]["name"],
Database.rental_pool[index]["attack"],
Database.rental_pool[index]["defense"],
Database.rental_pool[index]["speed"],
Database.rental_pool[index]["moves"]
])
		PlayerData.player_team[player_team_list.get_item_count()-1] = Database.rental_pool[index].duplicate()
		if player_team_list.get_item_count() == 3:
			start_button.disabled = false

func _on_reset_pressed() -> void:
	player_team_list.clear()
	start_button.disabled = true

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
		rental_pool.set_item_tooltip(i, """%s
Attack: %s
Defense: %s
Speed: %s
Moves: %s
		"""
% [Database.rental_pool[i]["name"],
Database.rental_pool[i]["attack"],
Database.rental_pool[i]["defense"],
Database.rental_pool[i]["speed"],
Database.rental_pool[i]["moves"]
])

func populate_enemy_team() -> void:
	for i in range(3):
		enemy_team_list.add_item(
			Database.enemy_team[PlayerData.current_opponent][i]["name"],
			load(Database.enemy_team[PlayerData.current_opponent][i]["icon"]),
			false)
		enemy_team_list.set_item_tooltip(i, """%s
Attack: %s
Defense: %s
Speed: %s
Moves: %s
""" %
[
	Database.enemy_team[PlayerData.current_opponent][i]["name"],
	Database.enemy_team[PlayerData.current_opponent][i]["attack"],
	Database.enemy_team[PlayerData.current_opponent][i]["defense"],
	Database.enemy_team[PlayerData.current_opponent][i]["speed"],
	Database.enemy_team[PlayerData.current_opponent][i]["moves"]
]
)
