extends CharacterBody2D


var health = 30
var times_repeated = 0 # tracks attack repetitions, set to zero before next pattern
var hit_flash_frames = 0 # duration of flash effect on hit

# ATTACK 1
var burst_scene = preload("res://scenes/patterns/eye/eightway_burst.tscn")
var burst_attack_rotation = 0 # tracks current rotation, in degrees
var burst_attack_rotation_increment = 12 # amount to rotate by
var burst_attack_delay = 0.05 # time between shots
var burst_attack_repeat_amount = 16 # shots before next pattern

# ATTACK 2
var tracking_circle_scene = preload("res://scenes/patterns/eye/targeting_circle.tscn")
var targeting_circle_delay = 0.28 # time between shots
var targeting_circle_repeat_amount = 8 # shots before next pattern

# ATTACK 3





func _ready():
	# start attacking after a delay
	get_tree().create_timer(1).timeout.connect(burst_attack)


func _physics_process(_delta):
	if hit_flash_frames > 0:
		self_modulate = Color(2,2,2)
		hit_flash_frames -= 1
	else:
		self_modulate = "ffffff"


func burst_attack():
	# dont attack if dead
	if health > 0:
		
		# create instance
		var new_attack = burst_scene.instantiate()
		
		# set position to eye's pupil
		new_attack.position = position + Vector2(0,15) 
		
		# rotate attack on each repeat to create spiral effect
		new_attack.rotation_degrees = burst_attack_rotation 
		burst_attack_rotation += burst_attack_rotation_increment
		if burst_attack_rotation == 360:
			burst_attack_rotation = 0
		
		# add to tree
		get_tree().root.call_deferred("add_child", new_attack)
		
		# increment times repeated
		times_repeated += 1
		
		# call self if repetitions left
		if times_repeated < burst_attack_repeat_amount:
			get_tree().create_timer(burst_attack_delay).timeout.connect(burst_attack)
		# call next attack when done repeating
		else:
			times_repeated = 0 # reset when ending
			get_tree().create_timer(1).timeout.connect(targeting_circle) # call attack 2


func targeting_circle():
	if health > 0:
		
		var new_attack = tracking_circle_scene.instantiate()
		
		new_attack.position = position + Vector2(0,15) # set position to eye's pupil
		
		# stop here until inside tree
		# should prevent random crash
		while get_tree() == null:
			print_debug("tree broke 2")
		
		get_tree().root.call_deferred("add_child", new_attack)
		
		times_repeated += 1
		
		if times_repeated < targeting_circle_repeat_amount:
			get_tree().create_timer(targeting_circle_delay).timeout.connect(targeting_circle)
		else:
			times_repeated = 0 # reset for next pattern
			get_tree().create_timer(1).timeout.connect(burst_attack) # call next attack


func take_damage():
	# on hit
	health -= 1
	$DamageSound.play()
	hit_flash_frames = 3
	print_debug(health)
	
	# death effects
	if health <= 0:
		Events.boss_defeated.emit()
		$AnimatedSprite2D.play("death")
		$DeathSound.play()
		
		# wait for animation to finish, then despawn
		await get_tree().create_timer(5).timeout
		queue_free()

