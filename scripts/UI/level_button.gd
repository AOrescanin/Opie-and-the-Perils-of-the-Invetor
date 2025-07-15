extends Button

# **************************************************************************************************

@export_file var level_path

@export var lvl_num: int

@onready var transition = $FadeTransition/CanvasLayer/Transition


func _on_pressed():
	if level_path == null:
		return
		
	transition.play("fade_out")	

# **************************************************************************************************

func _on_transition_animation_finished(anim_name):
	SaverLoader.load_game(true, lvl_num)
	get_tree().change_scene_to_file(level_path)


func _on_focus_entered():
	get_parent().get_parent().get_parent().get_parent().set_opie_position(lvl_num)
	 # This it not a clean way to do this, I should probably forget dynamically making the buttons and
	 # create them in the scene and @export them directly to level_select script, and hide them until they are unlocked,
	 # but this works for now. ***** MAYBE HAVE EACH BUTTON AHVE A CHILD OPIE YOU SHOW AND HIDE ON FOCUS ENTERED AND EXITED
