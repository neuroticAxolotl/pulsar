extends Path2D


@onready var player_node = get_node_or_null("/root/Game/Player")
var player_position = Vector2(225,500) # default if player not found
var starting_position = Vector2.ZERO # set by spawner

# Called when the node enters the scene tree for the first time.
func _ready():

	child_order_changed.connect(check_despawn)
	
	# override default if player found
	if player_node:
		player_position = player_node.position
	
	# make path go through player and end off screen
	var target_direction = starting_position.direction_to(player_position) # get direction to player
	var target_position = starting_position + target_direction * 950 # target in that direction 950 px away
	
	curve.clear_points() # precaution, shouldnt be needed
	
	# create path
	curve.add_point(starting_position)
	curve.add_point(target_position)


# despawn when childen have despawned
func check_despawn():
	if get_child_count() == 0:
		call_deferred("queue_free")
