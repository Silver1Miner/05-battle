extends Control

onready var level_select_button = $menu_options/level_select
onready var settings_button = $menu_options/settings
onready var quit_button = $menu_options/quit
onready var battle_menu = $battle_menu
onready var settings_menu = $settings_menu
onready var back1 = $battle_menu/back
onready var back2 = $settings_menu/back

func _ready() -> void:
	if OS.get_name() == "HTML5":
		quit_button.visible = false
	if level_select_button.connect("pressed", self, "_on_level_select_pressed") != OK:
		push_error("level select button connect fail")
	if settings_button.connect("pressed", self, "_on_settings_pressed") != OK:
		push_error("level select button connect fail")
	if quit_button.connect("pressed", self, "_on_quit_pressed") != OK:
		push_error("level select button connect fail")
	if back1.connect("pressed", self, "_on_back_pressed") != OK:
		push_error("back button connect fail")
	if back2.connect("pressed", self, "_on_back_pressed") != OK:
		push_error("back button connect fail")
	if PlayerData.battle_menu_on:
		battle_menu.visible = true

func _on_level_select_pressed() -> void:
	settings_menu.visible = false
	battle_menu.visible = true

func _on_settings_pressed() -> void:
	settings_menu.visible = true
	battle_menu.visible = false

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_back_pressed() -> void:
	battle_menu.visible = false
	settings_menu.visible = false
