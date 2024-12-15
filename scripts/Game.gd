extends Node2D

var main_menu_scene = preload("res://scenes/main_menu.tscn")

@onready var tree = get_tree()

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.player_died.connect(on_player_death)
	Events.boss_defeated.connect(on_boss_defeat)


func clear_bullets():
	tree.call_group("Bullets", "despawn")


func on_player_death():
	await tree.create_timer(1).timeout # wait for death animation
	clear_bullets() # despawn bullets
	$ScreenFade.target_color = Color.BLACK # begin fade
	await tree.create_timer(0.5).timeout # wait for fade to finish
	Events.load_scene_from_path("res://scenes/main_menu.tscn") # change scene to main menu


func on_boss_defeat():
	await tree.create_timer(3).timeout # wait for death animation
	clear_bullets() # despawn bullets
	$ScreenFade.target_color = Color.BLACK # begin fade
	await tree.create_timer(0.5).timeout # wait for fade to finish
	Events.load_scene_from_path("res://scenes/win_screen.tscn") # change scene to win screen
