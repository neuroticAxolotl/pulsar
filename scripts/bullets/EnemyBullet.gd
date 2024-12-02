extends Area2D


@export var lifetime = 5 ## in seconds


func _ready():
	body_entered.connect(_on_body_entered)
	$AnimatedSprite2D.play("default")
	var despawn_timer = get_tree().create_timer(lifetime)
	despawn_timer.timeout.connect(despawn)


func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.take_damage()
		despawn()


func despawn():
	queue_free()
