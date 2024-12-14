extends HSlider


# Called when the node enters the scene tree for the first time.
func _ready():
	value_changed.connect(update_setting)
	value = Settings.effects_volume # set slider to match saved value on load


# update saved value when slider moved
func update_setting(new_value):
	Settings.effects_volume = new_value
	$TestSfx.play() # play a noise to preview volume
