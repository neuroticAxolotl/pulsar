extends Path2D


@onready var player_node = get_node_or_null("/root/Game/Player")
var player_position = Vector2(225,500) # default if player not found


# Called when the node enters the scene tree for the first time.
func _ready():
	child_order_changed.connect(check_despawn)
	
	# override default if player found
	if player_node:
		player_position = player_node.global_position
	
	# make path go through player and end off screen
	var target_direction = position.direction_to(player_position)
	var target_position = target_direction * 1200
	
	curve.clear_points() # precaution, shouldnt be needed
	
	# create path
	curve.add_point(position)
	curve.add_point(target_position)


# despawn when childen have despawned
func check_despawn():
	if get_child_count() == 0:
		call_deferred("queue_free")
