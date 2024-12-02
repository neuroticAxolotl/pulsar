extends Marker2D

class_name MoveCircle


@export var speed = 200
@export var direction = 90 ## in degrees
@export var direction_change = -4 ## degrees per tick

var velocity = Vector2.ZERO


func _ready():
	child_order_changed.connect(check_despawn)


func check_despawn():
	if get_child_count() == 0:
		queue_free()


func _physics_process(delta):
	velocity = speed * Vector2.from_angle(deg_to_rad(direction)) * delta
	direction += direction_change
	position += velocity

