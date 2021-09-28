extends AudioStreamPlayer

var tracks := [
	"res://assets/audio/Battle_Ranger.ogg",
	"res://assets/audio/Battle_Ranger-Battle.ogg"
]

func _ready() -> void:
	pass

func change_track(new_track) -> void:
	stream = load(tracks[new_track])
	play(0.0)
