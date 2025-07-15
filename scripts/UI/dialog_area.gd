extends Area2D

# **************************************************************************************************

@export var text_key: String =  ""
@export var end_scene: bool = false

var area_active: bool = false
var is_disabled: bool = false

@onready var transition = $FadeTransition/CanvasLayer/Transition


func _ready():
	SignalBus.connect("disable_dialog", Callable(self, "on_disable_dialog"))
	SignalBus.connect("enable_dialog", Callable(self, "on_enable_dialog"))
	
# **************************************************************************************************

func _input(event):
	# Start dialog
	if area_active and event.is_action_pressed("ui_accept"):
		SignalBus.emit_signal("display_dialog", text_key)
		
# **************************************************************************************************

func _on_area_entered(area):
	area_active = true
	print(text_key)
	if is_disabled == false:
		SignalBus.emit_signal("display_dialog", text_key)

# **************************************************************************************************

func _on_area_exited(area):
	area_active = false

# **************************************************************************************************

func on_disable_dialog(key):
	if key == text_key:
		monitoring = false
		
		# Controls if the dialog end should also end the current level
		if end_scene:
			transition.play("fade_out")
	
# **************************************************************************************************

func on_enable_dialog():
	monitoring = true
	
# **************************************************************************************************

func _on_transition_animation_finished(anim_name):
	GameManager.in_level = false
	GameManager.player_position = Vector2(369, 369)
	SaverLoader.save_game()
	GameManager.reset_level()
	get_tree().change_scene_to_file("res://scenes/UI/level_select.tscn")
