class_name Checkpoint
extends Node2D

# **************************************************************************************************

@export var spawn_point: bool = false

var is_activated: bool = false


func activate():
	GameManager.current_checkpoint = self
	is_activated = true
	
# **************************************************************************************************

func _on_area_2d_body_entered(_body):
	if not is_activated:
		activate()
