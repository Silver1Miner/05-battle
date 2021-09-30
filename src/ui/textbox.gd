extends Control

signal text_finished
var page := "0"
var text_playing = true
var dialogue = {}

onready var text = $panels/textbox/text
onready var profile = $panels/namebox/profile
onready var timer = $Timer
onready var next_button = $panels/buttonbox/next
onready var skip_button = $panels/buttonbox/skip

func _ready() -> void:
	timer.wait_time = 0.02
	timer.autostart = true
	if timer.connect("timeout", self, "_on_timer_timeout") != OK:
		push_error("timer connect fail")
	if skip_button.connect("pressed", self, "_on_skip_pressed") != OK:
		push_error("skip button connect fail")
	if PlayerData.current_opponent == 0:
		if get_parent().name == "selection":
			initialize(intro_dialogue)
		elif get_parent().name == "interface":
			initialize(battle_dialogue)
	elif PlayerData.current_opponent == 3 and get_parent().name == "interface":
		initialize(end_dialogue)
	else:
		visible = false

var profiles = {
	"blu-base": preload("res://assets/avatars/officer-blu-base.png"),
	"blu-happy": preload("res://assets/avatars/officer-blu-happy.png"),
	"blu-sad": preload("res://assets/avatars/officer-blu-sad.png"),
	"red-base": preload("res://assets/avatars/officer-red-base.png"),
	"red-happy": preload("res://assets/avatars/officer-red-happy.png"),
	"red-sad": preload("res://assets/avatars/officer-red-sad.png"),
}
var intro_dialogue = {
	"0": {
		"name": "red-base",
		"text": "Hey, you're the new genius tactical advisor, right? Nice to meet you!"
	},
	"1": {
		"name": "red-happy",
		"text": "I heard great things about you from one of the combat engineers!"
	},
	"2": {
		"name": "red-base",
		"text": "Well, I'll brief you on the current assignment."
	},
	"3": {
		"name": "red-base",
		"text": "It's pretty straight forward. We need to fight off an enemy squad of battle rangers."
	},
	"4": {
		"name": "red-base",
		"text": "To do that, you'll need to select a squad to counter the enemy squad."
	},
	"5": {
		"name": "red-base",
		"text": "Mouse over each ranger to get a sense of their stats and abilities in battle."
	},
	"6": {
		"name": "red-base",
		"text": "My job? I'm just a combat medic. I'll be patching up our battle rangers in between the fights."
	},
	"7": {
		"name": "red-base",
		"text": "Everything is at your command, boss!"
	},
}

var battle_dialogue = {
	"0": {
		"name": "red-base",
		"text": "Alright, our first battle! The goal is simple: knock out all three enemy rangers before they knock out ours."
	},
	"1": {
		"name": "red-base",
		"text": "With each turn, we can switch which ranger we have deployed, or order our deployed ranger to attack."
	},
	"2": {
		"name": "red-base",
		"text": "Each ranger has three different attack abilities. Each attack has a respective elemental type which influences its effectiveness."
	},
	"3": {
		"name": "red-base",
		"text": "Some attacks do damage, while others change ranger stats to be more effective in battle."
	},
	"4": {
		"name": "red-base",
		"text": "But the best way to get a hang of battling is to just fight and win a battle. Let's get to it!"
	},
}

var end_dialogue = {
	"0": {
		"name": "red-base",
		"text": "Well, this is the last battle for now. Let's make it a glorious one!"
	},
	"1": {
		"name": "blu-base",
		"text": "It's that same tactical advisor from before, isn't it? What a dangerous opponent."
	},
	"2": {
		"name": "blu-sad",
		"text": "Well... No turning back now."
	},
}

func initialize(scene) -> void:
	visible = true
	timer.start()
	dialogue = scene
	text_playing = true
	page = "0"
	if not page in dialogue:
		end_text()
	text.set_bbcode(dialogue[page]["text"])
	if dialogue[page]["name"] in profiles:
		profile.texture = profiles[dialogue[page]["name"]]
	text.set_visible_characters(0)
	set_process_input(true)

func _on_next_pressed() -> void:
	if text_playing:
		if text.get_visible_characters() > text.get_total_character_count():
			if int(page) < dialogue.size() - 1:
				page = str(int(page) + 1)
				text.set_bbcode(dialogue[page]["text"])
				if dialogue[page]["name"] in profiles:
					profile.texture = profiles[dialogue[page]["name"]]
				text.set_visible_characters(0)
			elif int(page) >= dialogue.size() - 1:
				end_text()
		else:
			text.set_visible_characters(text.get_total_character_count())

func _on_skip_pressed() -> void:
	if text_playing:
		end_text()

func _input(event) -> void:
	if text_playing:
		if event.is_action_pressed("ui_accept") or event.is_action_pressed("left_click"):
			_on_next_pressed()

func _on_timer_timeout() -> void:
	text.set_visible_characters(text.get_visible_characters()+1)

func end_text() -> void:
	get_tree().paused = false
	visible = false
	emit_signal("text_finished")
