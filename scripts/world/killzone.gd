class_name  Killzone
extends Area2D

# **************************************************************************************************

func _on_body_entered(_body):
	GameManager.respawn_player()

