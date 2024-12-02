extends Marker2D


var rotation_speed = 1 ## degree per frame


# Called when the node enters the scene tree for the first time.
func _ready():
	child_order_changed.connect(check_despawn)


func _physics_process(delta):
	for child in get_children():
		child.direction += rotation_speed


func check_despawn():
	if get_child_count() == 0:
		queue_free()
