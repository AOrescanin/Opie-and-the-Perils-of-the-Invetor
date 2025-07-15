class_name SaveMenu
extends Control

# **************************************************************************************************

var save1_exists: bool = false
var levels:Array[String] = ["res://scenes/world/levels/a_prologue.tscn", "res://scenes/world/levels/chapter_1.tscn"]

@onready var transition = $FadeTransition/CanvasLayer/Transition
@onready var save_slot = $MarginContainer/VBoxContainer/SaveSlot


func _ready():
	save_slot.grab_focus()
	
	if FileAccess.file_exists("user://savegame1.tres"):
		save_slot.text = "Save 1"
		save1_exists = true

# **************************************************************************************************

func _on_save_slot_pressed():		
	transition.play("fade_out")
	
# **************************************************************************************************

func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/UI/main_menu.tscn")





func _on_transition_animation_finished(anim_name):
	if not save1_exists:
		SaverLoader.create_new_save(1)
		get_tree().change_scene_to_file(levels[0].trim_suffix('.remap'))
		return
	
	SaverLoader.load_game(false, -1)
	if	GameManager.in_level:
		get_tree().change_scene_to_file(levels[GameManager.level_num])
	else:
		get_tree().change_scene_to_file("res://scenes/UI/level_select.tscn")
