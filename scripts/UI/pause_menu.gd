class_name PauseMenu
extends Control

# **************************************************************************************************

var action = 369

@onready var transition = $FadeTransition/CanvasLayer/Transition
@onready var resume = $MarginContainer/VBoxContainer/Resume


func _ready():
	GameManager.pause_menu = self

# **************************************************************************************************

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		GameManager.toggle_pause_menu()
		resume.grab_focus()

# **************************************************************************************************

func _on_resume_pressed():
	GameManager.toggle_pause_menu()

# **************************************************************************************************

func _on_retry_pressed():
	transition.play("fade_out")
	action = 0

# **************************************************************************************************

func _on_options_pressed():
	pass # Replace with function body.

# **************************************************************************************************

func _on_save_and_quit_pressed():
	transition.play("fade_out")
	action = 1

# **************************************************************************************************

func _on_return_to_map_pressed():
	transition.play("fade_out")
	action = 2

# **************************************************************************************************

func _on_restart_chapter_pressed():
	transition.play("fade_out")
	action = 3

# **************************************************************************************************

func _on_transition_animation_finished(anim_name):
	if action == 1:
		SaverLoader.save_game()
		GameManager.toggle_pause_menu()
		get_tree().change_scene_to_file("res://scenes/UI/main_menu.tscn")
	elif action == 2:
		GameManager.in_level = false
		SaverLoader.save_game()
		GameManager.toggle_pause_menu()
		get_tree().change_scene_to_file("res://scenes/UI/level_select.tscn")
	elif action == 3:
		GameManager.toggle_pause_menu()
		GameManager.restart_chapter()
	elif action == 0:
		GameManager.toggle_pause_menu()
		GameManager.respawn_player()
