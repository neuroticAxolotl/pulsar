extends Area2D


@export var lifetime = 5
@export var speed = 600


func _ready():
	body_entered.connect(_on_body_entered)
	$AnimatedSprite2D.play()
	var despawn_timer = Events.tree.create_timer(lifetime)
	despawn_timer.timeout.connect(despawn)


func _physics_process(delta):
	position += Vector2.UP * speed * delta


func _on_body_entered(body):
	if body.is_in_group("Bosses"):
		body.take_damage()
		despawn()


func despawn():
	queue_free()
