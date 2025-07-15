extends StaticBody2D

# Doors are controlled by signals from 'Lanterns'
# FIGURE OUT A BETTER WAY TO DO THIS IF NEED BE, MULTIPLE SIGNALS SEEMS WEIRD, PROBABLY USE SIGNAL BUS

# **************************************************************************************************

func _on_lantern_lantern_activated():
	queue_free()

# **************************************************************************************************

func _on_lantern_2_lantern_activated():
	queue_free()


func _on_lantern_11_lantern_activated():
	visible = true
