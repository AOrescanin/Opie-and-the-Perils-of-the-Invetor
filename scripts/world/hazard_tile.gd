class_name HazardTile
extends Area2D

# **************************************************************************************************

var hit = false

func _on_body_entered(_body):
	if not hit:
		GameManager.respawn_player()
		hit = true
