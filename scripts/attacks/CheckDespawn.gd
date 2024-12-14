extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	child_order_changed.connect(check_despawn)


func check_despawn():
	if get_child_count() == 0:
		queue_free()
