extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	RenderingServer.set_default_clear_color(Color.BLACK)
	

func _process(_delta):
	# remove nodes not on whitelist
	# makes bullets not appear in main menu after death
	for sibling in Events.tree.root.get_children():
		if sibling.name not in ["MainMenu", "Settings", "Events"]:
			sibling.queue_free()
