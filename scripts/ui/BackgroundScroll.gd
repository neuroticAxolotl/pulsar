extends TextureRect

var i = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if position.y >= 0:
		position.y = -1000
	elif i % 2 == 0:
		position.y += 1
	i += 1
