extends Path2D


@onready var player_node = get_node_or_null("/root/Game/Player")
var player_position = Vector2(225,500) # default if player not found, shouldnt be needed
var starting_position = Vector2(0,0) # zero is at path2d.position


# Called when the node enters the scene tree for the first time.
func _ready():
	
	# if children change, check if they've all despawned
	child_order_changed.connect(check_despawn)
	
	# override default if player found
	if player_node:
		player_position = player_node.global_position
	
	# make path go through player and end off screen
	var target_direction = global_position.direction_to(player_position) # global position to player global position
	var target_position = target_direction * 950 # target in that direction 950 px away
	
	# create path
	curve.add_point(starting_position)
	curve.add_point(target_position)


# despawn when all children have despawned
func check_despawn():
	if get_child_count() == 0:
		call_deferred("queue_free")
