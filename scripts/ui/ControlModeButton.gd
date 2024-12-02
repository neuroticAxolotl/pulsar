extends CheckButton


# Called when the node enters the scene tree for the first time.
func _ready():
	update_setting()
	pressed.connect(update_setting)


func update_setting():
	Settings.mouse_control = button_pressed
