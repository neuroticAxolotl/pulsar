extends PathFollow2D


@export var speed = 300


func _ready():
	child_order_changed.connect(check_despawn)


func _physics_process(delta):
	# delete if finished
	if progress_ratio >= 0.99:
		queue_free()
	
	progress += speed * delta


func check_despawn():
	if get_child_count() <= 0:
		queue_free()
