extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	pressed.connect(hide_parent)


func hide_parent():
	get_parent().visible = false
