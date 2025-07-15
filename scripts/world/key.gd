extends StaticBody2D

# **************************************************************************************************

signal door_opened

var key_taken = false
var in_door_zone = false


func _on_area_2d_body_entered(body):
	if body is Player:
		if key_taken == false:
			key_taken = true
			$Sprite2D.queue_free()

# **************************************************************************************************

func _process(delta):
	if key_taken and in_door_zone:
		emit_signal("door_opened")
		print("door opened")

# **************************************************************************************************

func _on_door_zone_body_entered(body):
	if body is Player:
		in_door_zone = true
		print(in_door_zone)
		
# **************************************************************************************************

func _on_door_zone_body_exited(body):
	if body is Player:
		in_door_zone = false
		print(in_door_zone)
