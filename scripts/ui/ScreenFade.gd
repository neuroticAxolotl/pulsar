extends TextureRect


@export var starting_color = Color(0, 0, 0, 1)
@export var target_color = Color(0, 0, 0, 0)
@export var fade_speed = 0.2


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = true
	modulate = starting_color

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	modulate = lerp(modulate, target_color, fade_speed)


