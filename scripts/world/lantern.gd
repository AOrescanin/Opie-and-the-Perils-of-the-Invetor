extends StaticBody2D

# **************************************************************************************************

signal lantern_activated

var lantern_active = false


func _on_area_2d_body_entered(body):
	if body is Player:
		if lantern_active == false:
			lantern_active = true
			$Sprite2D.queue_free()
			$Sprite2D2.visible = true
			emit_signal("lantern_activated")
