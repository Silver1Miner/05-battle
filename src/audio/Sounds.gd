extends AudioStreamPlayer

var autoshot = preload("res://assets/audio/Autoshot.wav")
var cannon = preload("res://assets/audio/Cannon.wav")
var splode = preload("res://assets/audio/Splode.wav")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func match_sound(index) -> void:
	match index:
		0:
			stream = cannon
		1:
			stream = autoshot
		3:
			stream = splode
	play()
