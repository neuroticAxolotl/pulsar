extends Button

@onready var fader = get_node("/root/WinScreen/ScreenFade")

# Called when the node enters the scene tree for the first time.
func _ready():
	pressed.connect(fade_to_black)

func fade_to_black():
	fader.target_color = Color.BLACK
	get_tree().create_timer(0.8).timeout.connect(return_to_menu)


func return_to_menu():
	Events.load_main_menu()
