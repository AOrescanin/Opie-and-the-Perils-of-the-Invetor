extends Node2D

# **************************************************************************************************

@onready var transition = $Animations/FadeTransition/CanvasLayer/Transition


func _ready():
	GameManager.level_num = 1 # Set level number for saving a loading purposes when level is entered
	GameManager.in_level = true
	transition.play("fade_in")
	
	if FileAccess.file_exists("user://savegame1.tres"): # Not sure if I need this, troublshooting?
		if GameManager.player_position != Vector2(369, 369):
			GameManager.player.position = GameManager.player_position
	
