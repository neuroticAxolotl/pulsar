extends AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	finished.connect(play)

func _process(_delta):
	volume_db = linear_to_db(Settings.music_volume)
