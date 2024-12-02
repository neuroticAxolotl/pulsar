extends HSlider


# Called when the node enters the scene tree for the first time.
func _ready():
	value_changed.connect(update_setting)


func update_setting(new_value):
	Settings.effects_volume = new_value
	$TestSfx.play()
