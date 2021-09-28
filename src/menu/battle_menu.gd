extends ColorRect

onready var battle1 = $battle_select/battle1
onready var battle2 = $battle_select/battle2
onready var battle3 = $battle_select/battle3
onready var battle4 = $battle_select/battle4
onready var battle5 = $battle_select/battle5


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if battle1.connect("pressed", self, "_on_battle1_pressed") != OK:
		push_error("battle button connect fail")
	if battle2.connect("pressed", self, "_on_battle2_pressed") != OK:
		push_error("battle button connect fail")
	if battle3.connect("pressed", self, "_on_battle3_pressed") != OK:
		push_error("battle button connect fail")
	if battle4.connect("pressed", self, "_on_battle4_pressed") != OK:
		push_error("battle button connect fail")
	if battle5.connect("pressed", self, "_on_battle5_pressed") != OK:
		push_error("battle button connect fail")

func _on_battle1_pressed() -> void:
	PlayerData.current_opponent = 0
	go_to_select_screen()

func _on_battle2_pressed() -> void:
	PlayerData.current_opponent = 1
	go_to_select_screen()

func _on_battle3_pressed() -> void:
	PlayerData.current_opponent = 2
	go_to_select_screen()

func _on_battle4_pressed() -> void:
	PlayerData.current_opponent = 3
	go_to_select_screen()

func _on_battle5_pressed() -> void:
	PlayerData.current_opponent = 4
	go_to_select_screen()

func go_to_select_screen() -> void:
	if get_tree().change_scene("res://src/selection/selection.tscn") != OK:
		push_error("fail to load world")
