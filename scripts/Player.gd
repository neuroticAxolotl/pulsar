extends CharacterBody2D

# reuse tree
@onready var tree = Events.tree

var health = 3
var iframes = 0
var max_iframes = 50

var mouse_speed = 400
var mouse_acceleration = 100

var keyboard_speed = 300
var keyboard_acceleration = 50

var allow_movement = true

# parry numbers (in seconds)
var parry_cooldown_remaining = 0
var parry_cooldown_max = 0.38
var parry_duration = 0
var parry_duration_max = 0.2


var player_bullet = preload("res://scenes/player_bullet.tscn")


func _ready():
	Events.boss_defeated.connect(on_boss_defeated)


func _process(delta):
	if allow_movement:
		if parry_cooldown_remaining <= 0 and Input.is_action_just_pressed("pulse"):
			$ParryAnimation.play("default")
			$ParrySound.play()
			parry_duration = parry_duration_max
			parry_cooldown_remaining = parry_cooldown_max
		
		if parry_duration > 0:
			parry()
	
	parry_duration -= delta
	parry_cooldown_remaining -= delta


func _physics_process(delta):
	if Settings.mouse_control == true:
		var mouse_position = get_viewport().get_mouse_position()
		var direction_to_mouse = position.direction_to(mouse_position)
		var distance_to_mouse = position.distance_to(mouse_position)
		
		# always move toward mouse
		velocity.x = move_toward(velocity.x, mouse_speed * direction_to_mouse.x, mouse_acceleration)
		velocity.y = move_toward(velocity.y, mouse_speed * direction_to_mouse.y, mouse_acceleration)
		
		# limit velocity to not go past mouse position
		if distance_to_mouse < velocity.length() * delta:
			velocity = velocity.limit_length(distance_to_mouse)
		
		
	# keyboard controls
	else:
		var x_input = Input.get_axis("left", "right")
		var y_input = Input.get_axis("up", "down")
		
		if x_input or y_input:
			velocity.x = move_toward(velocity.x, keyboard_speed * x_input, keyboard_acceleration)
			velocity.y = move_toward(velocity.y, keyboard_speed * y_input, keyboard_acceleration)
		else:
			velocity.x = move_toward(velocity.x, 0, keyboard_acceleration)
			velocity.y = move_toward(velocity.y, 0, keyboard_acceleration)
	
	# movement gets disabled when player or boss dies
	if allow_movement:
		move_and_slide()
	
	# when invincible after getting hit
	if iframes > 0:
		# toggle visibility every 5 frames for blinking effect
		if iframes % 5 == 0:
			visible = not visible
		
		iframes -= 1
	# when not invincible
	else:
		visible = true
		# re-enable collider only while alive
		if allow_movement:
			$CollisionShape2D.set_deferred("disabled", false)
		


# called by bullets
func take_damage():
	if iframes <= 0:
		$CollisionShape2D.set_deferred("disabled", true)
		health -= 1
		$DamageSound.play()
		iframes = max_iframes
	
	# on death effects
	if health <= 0:
		iframes = 0 # disables blinking
		$CollisionShape2D.set_deferred("disabled", true)
		Events.player_died.emit()
		$ShipAnimation.play("death")
		$DeathSound.play()
		allow_movement = false
		await tree.create_timer(0.5).timeout
		queue_free()


func parry():
	var areas = $ParryArea.get_overlapping_areas()
	for area in areas:
		if area.is_in_group("Parryable"):
			var new_bullet = player_bullet.instantiate()
			new_bullet.position = area.global_position
			tree.root.add_child(new_bullet)
			area.queue_free()


# makes player invincible and locks them in place
func on_boss_defeated():
	allow_movement = false
	$CollisionShape2D.set_deferred("disabled", true)
	
