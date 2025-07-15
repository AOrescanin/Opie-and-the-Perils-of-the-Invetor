extends StaticBody2D

# **************************************************************************************************

var time = 1
var is_falling = false

@onready var collision_shape = $CollisionShape2D
@onready var collision_detection = $Area2D/CollisionShape2D
@onready var ready_sprite = $Ready
@onready var falling_sprite = $Falling
@onready var outline_sprite = $Outline


func _ready():
	set_process(false) # Process begins false and is triggered by player

# **************************************************************************************************

func _process(delta):
	time += 1
	falling_sprite.position += Vector2(0, sin(time) * 1.2) # Shake sprite

# **************************************************************************************************

func _on_area_2d_body_entered(body):
	if body is Player and not is_falling: # Player triggers process
		set_process(true)
		ready_sprite.visible = false
		is_falling = true
		$DisappearTimer.start(1.5)

# **************************************************************************************************

func _on_disappear_timer_timeout():
	# Makes platform disappear
	$RespawnTimer.start(3)
	set_process(false)
	falling_sprite.visible = false
	outline_sprite.visible = true
	collision_shape.disabled = true
	collision_detection.disabled = true

# **************************************************************************************************

func _on_respawn_timer_timeout():
	# Makes platform reappear
	ready_sprite.visible = true
	falling_sprite.visible = true
	outline_sprite.visible = false
	is_falling = false
	collision_shape.disabled = false
	collision_detection.disabled = false
