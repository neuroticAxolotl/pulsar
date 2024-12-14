extends HSlider


# Called when the node enters the scene tree for the first time.
func _ready():
	value_changed.connect(update_setting) 
	value = Settings.music_volume # set slider to match saved value on load


# save value when it changes
func update_setting(new_value):
	Settings.music_volume = new_value
