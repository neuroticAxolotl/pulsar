extends Marker2D

class_name MoveWave


@export var angle = 90.0 ## 90 for horizontal movement, 0 for vertical
@export var amplitude = 80.0 ## height of wave peaks
@export var phase = 0.0 ## starting offset. 1.5 is halfway through the cycle
@export var period = 1.0 ## how often waves repeat

var t = 0


func _ready():
	child_order_changed.connect(check_despawn)


func check_despawn():
	if get_child_count() == 0:
		queue_free()


func _physics_process(delta):
	var wave_vector = Vector2.from_angle(deg_to_rad(angle)).normalized().orthogonal() * amplitude * sin(period * (t - phase))
	position += wave_vector * delta
	t += delta

