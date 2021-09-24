extends AudioStreamPlayer

var tracks := []

func _ready() -> void:
	pass

func change_track(new_track) -> void:
	stream = tracks[new_track]
	play(0.0)
