extends Node

# Player
signal player_died

# Bosses
signal boss_defeated


func load_main_menu():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func load_game():
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func load_win_screen():
	get_tree().change_scene_to_file("res://scenes/win_screen.tscn")
