extends AudioStreamPlayer


func _process(_delta):
	volume_db = linear_to_db(Settings.effects_volume)
