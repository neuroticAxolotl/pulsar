extends Marker2D

@export var repeat_times = 5
@export var delay = 0.25

var times_repeated = 0

var scene = preload("res://scenes/patterns/path_target_player.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	child_order_changed.connect(check_despawn)
	repeat(scene)


func repeat(scene):
	var new_scene = scene.instantiate()
	call_deferred("add_child", new_scene)
	times_repeated += 1
	
	if times_repeated < repeat_times:
		get_tree().create_timer(delay).timeout.connect(repeat)


func check_despawn():
	if get_child_count() == 0:
		queue_free()
