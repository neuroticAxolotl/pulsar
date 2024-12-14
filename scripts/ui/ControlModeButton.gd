extends CheckButton


# Called when the node enters the scene tree for the first time.
func _ready():
	pressed.connect(update_setting)
	button_pressed = Settings.mouse_control # set button to match saved value on load


# update saved value when button is pressed
func update_setting():
	Settings.mouse_control = button_pressed
