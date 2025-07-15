class_name CutsceneTrigger
extends Node2D

# **************************************************************************************************

@export var type: String

@onready var cutscene_dialog = $CutsceneDialog


func _input(event):
	# End cutscene
	if GameManager.is_cutscene_playing and event.is_action_pressed("ui_accept"):
		if type == "explode":
			SignalBus.emit_signal("start_explosion")
		
		GameManager.is_cutscene_playing = false
		queue_free()

# **************************************************************************************************

func _on_area_2d_body_entered(body):
	# Start cutscene
	cutscene_dialog.visible = true
	GameManager.start_cutscene_1()
