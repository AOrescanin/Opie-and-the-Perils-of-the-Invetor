extends Node2D

# **************************************************************************************************

@onready var cpu_particles_2d = $CPUParticles2D


func _ready():
	SignalBus.connect("start_explosion", Callable(self, "on_start_explosion"))
	
# **************************************************************************************************

func on_start_explosion():
	cpu_particles_2d.emitting = true
