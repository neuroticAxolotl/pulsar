extends PathFollow2D


@export var speed = 300


func _physics_process(delta):
	# delete if finished
	if progress_ratio >= 1.0 and not loop:
		call_deferred("queue_free")
	
	progress += speed * delta
