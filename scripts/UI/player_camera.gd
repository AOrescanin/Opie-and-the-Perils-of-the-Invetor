class_name Camera
extends Camera2D

# **************************************************************************************************

# Amount of smoothing for camera follow. Value can be 0 to 1
var follow_smoothing: float = 0.1
# Smoothing value used by code. Used in case different values are needed
var smoothing: float
var current_room_center: Vector2
var current_room_size: Vector2
var zoom_view_size: Vector2

@onready var view_size:= get_viewport_rect().size #


func _ready():
	GameManager.camera = self
	
	#self.smoothing = false
	position_smoothing_enabled = false
	
	smoothing = 1
	await get_tree().create_timer(.2).timeout
	smoothing = follow_smoothing


# **************************************************************************************************

func _physics_process(_delta):
	# Get view size considering zoom value
	zoom_view_size = view_size / zoom
	
	# Get target position for the camera
	var target_position := calculate_target_position(current_room_center, current_room_size)
	
	# Lerp camera postion to target position
	position = lerp(position, target_position, smoothing)

# **************************************************************************************************

func calculate_target_position(room_center: Vector2, room_size: Vector2) -> Vector2:
	# The distance from the center of the room to the camera boundary on one side.
	# When the room is the same size as the screen the x and y margin are zero
	var x_margin: float = (room_size.x - zoom_view_size.x) / 2
	var y_margin: float = (room_size.y - zoom_view_size.y) / 2
	
	var return_position: Vector2 = Vector2.ZERO
	
	# if the zoom_view_size >= room_size the camera position should be room center
	if x_margin <= 0:
		return_position.x = room_center.x
	else:
		# Clamps the return position to the left and right limits if the x_margin is positive
		var left_limit: float = room_center.x - x_margin
		var right_limit: float = room_center.x + x_margin
		return_position.x = clamp(GameManager.player.position.x, left_limit, right_limit)
		print('here x')


	if y_margin <= 0:
		return_position.y = room_center.y
	else:
		# Clamps the return position to the top and bottom limits if the y_margin is positive
		var top_limit: float = room_center.y - y_margin
		var bottom_limit: float = room_center.y + y_margin
		return_position.y = clamp(GameManager.player.position.y, top_limit, bottom_limit)
	
	return return_position
