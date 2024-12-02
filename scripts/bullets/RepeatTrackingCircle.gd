extends Marker2D


var repeat_times = 8
var delay = 0.3
var cooldown = 4.0

var times_repeated = 0

var repeated_scene = preload("res://scenes/patterns/tracking_circle.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	child_order_changed.connect(check_despawn)
	repeat()


func repeat():
	var new_scene = repeated_scene.instantiate()
	new_scene.position = self.global_position
	get_tree().root.call_deferred("add_child", new_scene)
	times_repeated += 1
	
	if times_repeated < repeat_times:
		get_tree().create_timer(delay).timeout.connect(repeat)


func check_despawn():
	if get_child_count() == 0:
		queue_free()

