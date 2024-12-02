extends Marker2D

class_name MoveTowardPlayer


@export var speed = 200

@onready var player_node = get_node_or_null("/root/Game/Player")
var player_direction = Vector2.DOWN
var velocity = Vector2.ZERO


func _ready():
	child_order_changed.connect(check_despawn)
	
	if player_node:
		player_direction = position.direction_to(player_node.global_position).normalized()

func check_despawn():
	if get_child_count() == 0:
		queue_free()


func _physics_process(delta):
	velocity = speed * player_direction * delta
	position += velocity
