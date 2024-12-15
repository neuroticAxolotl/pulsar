extends Node


@warning_ignore("unused_signal")
signal player_died

@warning_ignore("unused_signal")
signal boss_defeated


func load_scene_from_path(filepath):
	get_tree().change_scene_to_file(filepath)
