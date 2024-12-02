extends CharacterBody2D


var mouse_speed = 400
var mouse_acceleration = 200

var keyboard_speed = 300
var keyboard_acceleration = 50

var allow_movement = true

# parry numbers (in seconds)
var parry_cooldown_remaining = 0
var parry_cooldown_max = 0.38
var parry_duration = 0
var parry_duration_max = 0.1


var player_bullet = preload("res://scenes/player_bullet.tscn")


func _ready():
	Events.boss_defeated.connect(on_boss_defeated)


func _process(delta):
	if parry_cooldown_remaining <= 0 and Input.is_action_just_pressed("pulse"):
		$ParryAnimation.play("default")
		$ParrySound.play()
		parry_duration = parry_duration_max
		parry_cooldown_remaining = parry_cooldown_max
	
	if parry_duration > 0:
		parry()
	
	parry_duration -= delta
	parry_cooldown_remaining -= delta


func _physics_process(_delta):
	if Settings.mouse_control == true:
		var mouse_position = get_viewport().get_mouse_position()
		var vector_toward_mouse = position.direction_to(mouse_position)
		
		if position.distance_to(mouse_position) > 5:
			velocity.x = move_toward(velocity.x, mouse_speed * vector_toward_mouse.x, mouse_acceleration)
			velocity.y = move_toward(velocity.y, mouse_speed * vector_toward_mouse.y, mouse_acceleration)
		else:
			velocity.x = move_toward(velocity.x, 0, mouse_acceleration)
			velocity.y = move_toward(velocity.y, 0, mouse_acceleration)
	else:
		var x_input = Input.get_axis("left", "right")
		var y_input = Input.get_axis("up", "down")
		
		if x_input or y_input:
			velocity.x = move_toward(velocity.x, keyboard_speed * x_input, keyboard_acceleration)
			velocity.y = move_toward(velocity.y, keyboard_speed * y_input, keyboard_acceleration)
		else:
			velocity.x = move_toward(velocity.x, 0, keyboard_acceleration)
			velocity.y = move_toward(velocity.y, 0, keyboard_acceleration)
	
	if allow_movement:
		move_and_slide()


# called by bullets
func take_damage():
	$CollisionShape2D.set_deferred("disabled", true)
	Events.player_died.emit()
	$ShipAnimation.play("death")
	$DeathSound.play()
	allow_movement = false
	await get_tree().create_timer(0.5).timeout
	queue_free()


func parry():
	var areas = $ParryArea.get_overlapping_areas()
	for area in areas:
		if area.is_in_group("EnemyBullets"):
			var new_bullet = player_bullet.instantiate()
			new_bullet.position = area.global_position
			get_tree().root.add_child(new_bullet)
			area.queue_free()


func on_boss_defeated():
	$CollisionShape2D.set_deferred("disabled", true)
	allow_movement = false

