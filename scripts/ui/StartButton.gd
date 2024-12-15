extends Button

@onready var fader = get_node("/root/MainMenu/ScreenFade")

# Called when the node enters the scene tree for the first time.
func _ready():
	pressed.connect(fade_to_black)

func fade_to_black():
	fader.target_color = Color.BLACK
	get_tree().create_timer(0.8).timeout.connect(start_game)


func start_game():
	Events.load_scene_from_path("res://scenes/game.tscn")
