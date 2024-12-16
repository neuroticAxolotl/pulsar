extends Node


@warning_ignore("unused_signal")
signal player_died

@warning_ignore("unused_signal")
signal boss_defeated


# same tree reference used by all nodes
@onready var tree = get_tree()


func load_scene_from_path(filepath):
	get_tree().change_scene_to_file(filepath)
