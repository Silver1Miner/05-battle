extends HBoxContainer

signal player_choice(action, choice)
onready var menu = $player_side/status/menu
onready var attack_menu = $player_side/status/attack_menu
onready var switch_menu = $player_side/status/switch_menu
onready var surrender_menu = $player_side/status/surrender_menu

func _on_attack_pressed() -> void:
	menu.visible = false
	attack_menu.visible = true

func _on_switch_pressed() -> void:
	menu.visible = false
	switch_menu.visible = true

func _on_surrender_pressed() -> void:
	menu.visible = false
	surrender_menu.visible = true

func _on_yes_pressed() -> void:
	surrender_menu.visible = false
	menu.visible = true
	emit_signal("player_choice", 0, 0) # 0 = Yield

func _on_attack1_pressed() -> void:
	attack_menu.visible = false
	menu.visible = true
	emit_signal("player_choice", 1, 0) # 1 = Attack

func _on_attack2_pressed() -> void:
	attack_menu.visible = false
	menu.visible = true
	emit_signal("player_choice", 1, 1)

func _on_attack3_pressed() -> void:
	attack_menu.visible = false
	menu.visible = true
	emit_signal("player_choice", 1, 2)

func _on_back_pressed() -> void:
	menu.visible = true
	attack_menu.visible = false
	switch_menu.visible = false
	surrender_menu.visible = false

func _on_unit1_pressed() -> void:
	switch_menu.visible = false
	menu.visible = true
	emit_signal("player_choice", 2, 0) # 2 = Switch

func _on_unit2_pressed() -> void:
	switch_menu.visible = false
	menu.visible = true
	emit_signal("player_choice", 2, 1)

func _on_unit3_pressed() -> void:
	switch_menu.visible = false
	menu.visible = true
	emit_signal("player_choice", 2, 2)
