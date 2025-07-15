extends Area2D

# **************************************************************************************************

const SPRING_POWER: int = 345


func _on_body_entered(body):
	if body is Player:
		body.spring(SPRING_POWER, rotation + PI/2.0)
