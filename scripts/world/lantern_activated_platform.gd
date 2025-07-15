extends Path2D

# FIGURE OUT A BETTER WAY TO DO THIS IF NEED BE, MULTIPLE SIGNALS SEEMS WEIRD, PROBABLY USE SIGNAL BUS

# **************************************************************************************************

@export var loop = true
@export var speed = 2.0
@export var speed_scale = 1.0

var activated = false

@onready var path = $PathFollow2D
@onready var animation = $AnimationPlayer
@onready var platform_off = $AnimatableBody2D/PlatformOff

func _ready():
	if not loop:
		animation.speed_scale = speed_scale

# **************************************************************************************************

func _process(delta):
	if activated:
		if not loop:
			animation.play("move")
			platform_off.visible = false
		else:	
			path.progress += speed

# **************************************************************************************************

func _on_lantern_3_lantern_activated():
	activated = true

func _on_lantern_4_lantern_activated():
	activated = true

func _on_lantern_5_lantern_activated():
	activated = true

func _on_lantern_6_lantern_activated():
	activated = true

func _on_lantern_7_lantern_activated():
	activated = true

func _on_lantern_8_lantern_activated():
	activated = true

func _on_lantern_9_lantern_activated():
	activated = true


func _on_lantern_10_lantern_activated():
	activated = true

func _on_lantern_12_lantern_activated():
	activated = true
