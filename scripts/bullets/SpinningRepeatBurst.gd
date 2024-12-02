extends Marker2D


var repeat_times = 16
var delay = 0.1
var rotation_speed = 15

var cooldown = 2.5

var current_rotation = 0

var times_repeated = 0

var repeated_scene = preload("res://scenes/patterns/burst.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	child_order_changed.connect(check_despawn)
	repeat()


func repeat():
	var new_scene = repeated_scene.instantiate()
	
	call_deferred("add_child", new_scene)
	new_scene.rotation_degrees = current_rotation
	
	times_repeated += 1
	self.current_rotation += rotation_speed
	
	if times_repeated < repeat_times:
		get_tree().create_timer(delay).timeout.connect(repeat)


func check_despawn():
	if get_child_count() == 0:
		queue_free()

