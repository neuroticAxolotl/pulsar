extends Area2D


@export var lifetime = 5 ## in seconds
@export_enum(
		"red", 
		"orange", 
		"yellow", 
		"green", 
		"lightblue", 
		"darkblue", 
		"violet", 
		"secret",
		"player",
		) var color: String = "green"

@export var parryable = false

func _ready():
	body_entered.connect(_on_body_entered)
	if parryable:
		$AnimatedSprite2D.play("player")
		add_to_group("Parryable")
	else:
		$AnimatedSprite2D.play(color)
	
	var despawn_timer = Events.tree.create_timer(lifetime)
	despawn_timer.timeout.connect(despawn)


func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.take_damage()
		despawn()


func despawn():
	queue_free()
