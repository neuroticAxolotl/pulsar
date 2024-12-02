extends Node2D

var main_menu_scene = preload("res://scenes/main_menu.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	Events.player_died.connect(on_player_death)
	Events.boss_defeated.connect(on_boss_defeat)

func on_player_death():
	await get_tree().create_timer(1).timeout # wait for death animation
	$ScreenFade.target_color = Color.BLACK # begin fade
	await get_tree().create_timer(0.5).timeout # wait for fade to finish
	Events.load_main_menu() # change scene


func on_boss_defeat():
	await get_tree().create_timer(3).timeout # wait for death animation
	$ScreenFade.target_color = Color.BLACK # begin fade
	await get_tree().create_timer(0.5).timeout # wait for fade to finish
	Events.load_win_screen() # change scene
