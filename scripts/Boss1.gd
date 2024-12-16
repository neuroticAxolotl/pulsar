extends CharacterBody2D

# reuse tree call
@onready var tree = Events.tree

var health = 30
var times_repeated = 0 # tracks attack repetitions, set to zero before next pattern
var hit_flash_frames = 0 # duration of flash effect on hit
var can_attack = true

# ATTACK 1
var burst_scene = preload("res://scenes/patterns/eye/eightway_burst.tscn")
var burst_attack_rotation = 0 # tracks current rotation, in degrees
var burst_attack_rotation_increment = 12 # amount to change rotation by
var burst_attack_delay = 0.05 # time between shots
var burst_attack_repeat_amount = 16 # shots before next pattern

# ATTACK 2
var tracking_circle_scene = preload("res://scenes/patterns/eye/targeting_circle.tscn")
var targeting_circle_delay = 0.28
var targeting_circle_repeat_amount = 8

# ATTACK 3
var circles_from_sides_scene = preload("res://scenes/patterns/eye/circles_from_sides.tscn")
var circles_from_sides_delay = 1
var circles_from_sides_repeat_amount = 4



func _ready():
	Events.player_died.connect(stop_attacks)
	# start attacking after a delay
	tree.create_timer(1).timeout.connect(spinning_burst)


func _physics_process(_delta):
	if hit_flash_frames > 0:
		$AnimatedSprite2D/HitFlash.visible = true
		hit_flash_frames -= 1
	else:
		$AnimatedSprite2D/HitFlash.visible = false
	


func spinning_burst():
	# dont attack if self or player dead
	if can_attack:
		
		# create instance
		var new_attack = burst_scene.instantiate()
		
		# set position to eye's pupil
		new_attack.position = position + Vector2(0,15) 
		
		# rotate attack on each repeat to create spiral effect
		new_attack.rotation_degrees = burst_attack_rotation 
		burst_attack_rotation += burst_attack_rotation_increment
		
		# add to tree
		tree.root.call_deferred("add_child", new_attack)
		
		# increment times repeated
		times_repeated += 1
		
		# call self if repetitions left
		if times_repeated < burst_attack_repeat_amount:
			tree.create_timer(burst_attack_delay).timeout.connect(spinning_burst)
		# call next attack when done repeating
		else:
			times_repeated = 0 # reset when ending
			tree.create_timer(1).timeout.connect(targeting_circles) # call attack 2


func targeting_circles():
	if can_attack:
		
		var new_attack = tracking_circle_scene.instantiate()
		
		new_attack.position = position + Vector2(0,15) # set position to eye's pupil
		
		tree.root.call_deferred("add_child", new_attack)
		
		times_repeated += 1
		
		if times_repeated < targeting_circle_repeat_amount:
			tree.create_timer(targeting_circle_delay).timeout.connect(targeting_circles)
		else:
			times_repeated = 0 # reset for next pattern
			tree.create_timer(1).timeout.connect(circles_from_sides) # call next attack


func circles_from_sides():
	if can_attack:
		var new_attack = circles_from_sides_scene.instantiate()
		
		tree.root.call_deferred("add_child", new_attack)
		
		times_repeated += 1
		
		if times_repeated < circles_from_sides_repeat_amount:
			tree.create_timer(circles_from_sides_delay).timeout.connect(circles_from_sides)
		else:
			times_repeated = 0 # reset for next pattern
			tree.create_timer(2.5).timeout.connect(spinning_burst) # call next attack


func stop_attacks():
	can_attack = false


func take_damage():
	# on hit
	health -= 1
	$DamageSound.play()
	hit_flash_frames = 2
	print_debug(health)
	
	# death effects
	if health <= 0:
		stop_attacks()
		Events.boss_defeated.emit()
		$AnimatedSprite2D.play("death")
		$DeathSound.play()
		
		# wait for animation to finish, then despawn
		await tree.create_timer(5).timeout
		queue_free()
