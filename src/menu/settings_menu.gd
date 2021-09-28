extends ColorRect

onready var music_volume = $volume_controls/music_volume
onready var sound_volume = $volume_controls/sound_volume


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if music_volume.connect("value_changed", self, "_on_music_value_changed") != OK:
		push_error("volume signal connect fail")
	if sound_volume.connect("value_changed", self, "_on_sound_value_changed") != OK:
		push_error("sound signal connect fail")


func _on_music_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Music"), linear2db(value)
	)

func _on_sound_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Sound"), linear2db(value)
	)
