extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	RenderingServer.set_default_clear_color(Color.BLACK)
	

func _process(delta):
	for sibling in get_tree().root.get_children():
		if sibling.name not in ["MainMenu", "Settings", "Events"]:
			sibling.queue_free()

