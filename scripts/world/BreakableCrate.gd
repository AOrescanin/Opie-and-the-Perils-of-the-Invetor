extends RigidBody2D

# **************************************************************************************************

# Destroy object when player swipes it
func _on_area_2d_area_entered(area):
	queue_free()
