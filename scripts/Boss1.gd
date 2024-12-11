extends CharacterBody2D


var health = 30
var times_repeated = 0


# ATTACK 1
var tracking_circle_scene = preload("res://scenes/patterns/eye/targeting_circle.tscn")
var attack_1_delay = 0.4
var attack_1_repeat_amount = 8


# ATTACK 2

# ATTACK 3





func _ready():
	# start attacking after a delay
	get_tree().create_timer(1).timeout.connect(attack_1)



func attack_1():
	if health > 0:
		var new_attack = tracking_circle_scene.instantiate()
		new_attack.starting_position = position# set position to eye's pupil
		
		# stop here until inside tree
		# should prevent random crash
		while get_tree == null:
			pass
		
		get_tree().root.call_deferred("add_child", new_attack)
		
		times_repeated += 1
		
		if times_repeated < attack_1_repeat_amount:
			get_tree().create_timer(attack_1_delay).timeout.connect(attack_1)
		elif times_repeated >= attack_1_repeat_amount:
			times_repeated = 0 # reset when ending
			get_tree().create_timer(1).timeout.connect(attack_1) # call attack 2


func take_damage():
	health -= 1
	$DamageSound.play()
	print_debug(health)
	if health <= 0:
		Events.boss_defeated.emit()
		$AnimatedSprite2D.play("death")
		$DeathSound.play()
		await get_tree().create_timer(5).timeout
		queue_free()

