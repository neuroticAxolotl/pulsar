extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	pressed.connect(show_options)

func show_options():
	get_node("/root/MainMenu/OptionsPanel").visible = true
