extends CharacterBody2D

var patterns = [
		preload("res://scenes/patterns/spinning_repeat_burst.tscn"),
		preload("res://scenes/patterns/repeat_tracking_circle.tscn"),
		preload("res://scenes/patterns/repeat_circles_from_sides.tscn")
]
var attack_index = 0
var attack_cooldown = 5
var health = 30


func _ready():
	# start attacking after a delay
	get_tree().create_timer(1).timeout.connect(attack)


func attack():
	if health > 0:
		var new_attack = patterns[attack_index].instantiate() # pick a random attack
		new_attack.position = global_position + Vector2(0, 15) # set position
		get_tree().root.call_deferred("add_child",new_attack) # add to tree
		#attack_cooldown = new_attack.get_meta("attack_cooldown") # get cooldown from metadata
		
		attack_index += 1
		if attack_index > patterns.size()-1:
			attack_index = 0
		
		if "cooldown" in new_attack:
			attack_cooldown = new_attack.cooldown
		else:
			attack_cooldown = 5
		
		get_tree().create_timer(attack_cooldown).timeout.connect(attack) # attack again after cooldown ends


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

