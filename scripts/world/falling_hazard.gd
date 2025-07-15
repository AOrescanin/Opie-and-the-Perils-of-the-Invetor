class_name FallingHazard
extends Node2D

# **************************************************************************************************

const SPEED: float = 150.0

var starting_position: Vector2
var current_speed: float = 0.0
var time = 1

@onready var fall_delay_timer = $FallDelayTimer
@onready var reset_timer = $ResetTimer


func _ready():
	# Store the orignal position for reset
	starting_position = position
	set_process(false)
	
# **************************************************************************************************
	
func _process(delta):
	time += 1
	position += Vector2(0, sin(time) * 1.2) # Shake sprite

# **************************************************************************************************

func _physics_process(delta):
	# Makes the object "fall" if the current_speed > 0
	position.y += current_speed * delta

# **************************************************************************************************

func _on_hitbox_body_entered(_body):
	# Kill the player
	GameManager.respawn_player()
	
# **************************************************************************************************

func _on_player_detector_body_entered(_body):
	# Start fall process
	fall_delay_timer.start()
	set_process(true)
	
# **************************************************************************************************

func _on_fall_delay_timer_timeout():
	# Set the fall speed and start reset process
	set_process(false)
	current_speed = SPEED
	reset_timer.start()

# **************************************************************************************************

func _on_reset_timer_timeout():
	# Reset object
	current_speed = 0
	position = starting_position
