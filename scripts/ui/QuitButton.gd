extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	pressed.connect(quit_game)


func quit_game():
	Events.tree.quit(0)
