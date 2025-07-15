class_name FaultyMachine
extends CharacterBody2D

# **************************************************************************************************

const SPEED = 200.0

var is_hit: bool = false


func _ready():
	# Set the initial velocity
	velocity = Vector2(-SPEED, -SPEED).normalized() * SPEED
	
# **************************************************************************************************	

func _physics_process(delta):
	# move the object and return collisions that are used to determine how to bounce
	var collision = move_and_collide(velocity * delta)
	
	if collision and not is_hit:
		velocity = velocity.bounce(collision.get_normal())

# **************************************************************************************************

func _on_area_2d_area_entered(area):
	is_hit = true
	SignalBus.emit_signal("enable_dialog")
