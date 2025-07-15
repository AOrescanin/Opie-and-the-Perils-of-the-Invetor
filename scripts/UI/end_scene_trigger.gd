extends Node2D

# **************************************************************************************************

@export var pos := Vector2(0,0)

@onready var transition = $FadeTransition/CanvasLayer/Transition


func _on_area_2d_area_entered(area):
	transition.play("fade_out")

# **************************************************************************************************

func _on_transition_animation_finished(anim_name):
	if(anim_name == "fade_out"):
		GameManager.player.position = pos
		transition.play("fade_in")
