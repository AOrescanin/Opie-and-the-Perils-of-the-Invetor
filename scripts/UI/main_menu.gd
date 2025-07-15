class_name MainMenu
extends Control

# **************************************************************************************************

@onready var transition = $FadeTransition/CanvasLayer/Transition
@onready var play = $MarginContainer/VBoxContainer/Play


func _ready():
	transition.play("fade_in")
	play.grab_focus()

# **************************************************************************************************

func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/UI/save_menu.tscn")
	
# **************************************************************************************************

func _on_options_pressed():
	get_tree().change_scene_to_file("res://scenes/UI/options_menu.tscn")
	
# **************************************************************************************************

func _on_quit_pressed():
	get_tree().quit()
