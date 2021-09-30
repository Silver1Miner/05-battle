extends HBoxContainer

onready var player_name := $player_side/status/display/name
onready var player_status := $player_side/status/display/status
onready var player_hp_bar := $player_side/status/display/hp_bar
onready var player_hp_values := $player_side/status/display/hp_values
onready var enemy_name := $enemy_side/status/display/name
onready var enemy_status := $enemy_side/status/display/status
onready var enemy_hp_bar := $enemy_side/status/display/hp_bar
onready var enemy_hp_values := $enemy_side/status/display/hp_values
onready var player_avatar = $player_side/panel/TextureRect
onready var enemy_avatar = $enemy_side/panel/TextureRect

var avatars = {
	"blu-base": preload("res://assets/avatars/officer-blu-base.png"),
	"blu-happy": preload("res://assets/avatars/officer-blu-happy.png"),
	"blu-sad": preload("res://assets/avatars/officer-blu-sad.png"),
	"red-base": preload("res://assets/avatars/officer-red-base.png"),
	"red-happy": preload("res://assets/avatars/officer-red-happy.png"),
	"red-sad": preload("res://assets/avatars/officer-red-sad.png"),
}

func update_player_avatar(avatar: String) -> void:
	player_avatar.texture = avatars[avatar]

func update_enemy_avatar(avatar: String) -> void:
	enemy_avatar.texture = avatars[avatar]

func update_player_all(new_name, new_status, new_values) -> void:
	update_player_name(new_name)
	update_player_status(new_status)
	update_player_hp(new_values)

func update_player_status(new_status: String) -> void:
	player_status.text = new_status

func update_player_name(new_name: String) -> void:
	player_name.text = new_name

func update_player_hp(hp_values: Vector2) -> void:
	var new_hp = hp_values.x
	var new_max_hp = hp_values.y
	player_hp_bar.max_value = new_max_hp
	player_hp_bar.value = new_hp
	player_hp_values.text = str(new_hp) + " / " + str(new_max_hp)

func update_enemy_all(new_name, new_status, new_values) -> void:
	update_enemy_name(new_name)
	update_enemy_status(new_status)
	update_enemy_hp(new_values)

func update_enemy_status(new_status: String) -> void:
	enemy_status.text = new_status

func update_enemy_name(new_name: String) -> void:
	enemy_name.text = new_name

func update_enemy_hp(hp_values: Vector2) -> void:
	var new_hp = hp_values.x
	var new_max_hp = hp_values.y
	enemy_hp_bar.max_value = new_max_hp
	enemy_hp_bar.value = new_hp
	enemy_hp_values.text = str(new_hp) + " / " + str(new_max_hp)

