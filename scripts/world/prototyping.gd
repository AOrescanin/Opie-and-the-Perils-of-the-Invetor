extends Node2D

# **************************************************************************************************

@onready var transition = $Animations/FadeTransition/CanvasLayer/Transition


func _ready():
	GameManager.level_num = 0
	GameManager.in_level = true
	transition.play("fade_in")
	
	if FileAccess.file_exists("user://savegame1.tres"):
		if GameManager.player_position != Vector2(369, 369): # Not sure if I need this
			GameManager.player.position = GameManager.player_position

