extends Node

# Singleton which stores references to other Nodes

# **************************************************************************************************

var current_level : int
var in_level : bool = false
var level_num: int = -1
var player_positions: Array = [Vector2(369, 369), Vector2(369, 369), Vector2(369, 369), Vector2(369, 369), Vector2(369, 369)]
var level_unlocked : Array = [true, false, false, false, false]
var level_completed : Array = [false, false, false, false, false]
var current_checkpoint : Checkpoint
var player : Player
var player_position : Vector2 = Vector2(369, 369)

@onready var respawn_timer = $RespawnTimer


func respawn_player():
	if current_checkpoint != null:
		respawn_timer.start()
		player.is_dead = true
		player.die()
		SaverLoader.save_game()
		
# **************************************************************************************************
		
func _on_respawn_timer_timeout():
	player.is_dead = false
	get_tree().reload_current_scene()
	SaverLoader.load_game(false, -1)
	
func restart_chapter():
	for checkpoint in get_tree().get_nodes_in_group("checkpoints"):
		if checkpoint.spawn_point:
			current_checkpoint = checkpoint
	respawn_timer.start()
	SaverLoader.save_game()
	
# **************************************************************************************************
	
var camera : Camera
var is_room_paused: bool = false

@onready var room_pause_timer = $RoomPauseTimer
		
		
func change_room(room_position: Vector2, room_size: Vector2) -> void:
	camera.current_room_center = room_position
	camera.current_room_size = room_size
	is_room_paused = true
	room_pause_timer.start()

# **************************************************************************************************

var is_cutscene_playing: bool = false
var is_dialogue_ready: bool = false


func start_cutscene_1():
	is_cutscene_playing = true
	
# **************************************************************************************************

func _on_room_pause_timer_timeout():
	is_room_paused = false
	
# **************************************************************************************************

var pause_menu : PauseMenu
var is_paused: bool = false

		
func toggle_pause_menu():
	if is_paused:
		pause_menu.hide()
		get_tree().paused = false
		#Engine.time_scale = 1
	else:
		pause_menu.show()
		get_tree().paused = true
		#Engine.time_scale = 0
		
	is_paused = !is_paused
	
# **************************************************************************************************	
	
func reset_level():
	level_completed[current_level] = true # not sure a better way to do this
	level_unlocked[current_level + 1] = true
	
	for checkpoint in get_tree().get_nodes_in_group("checkpoints"):
		if checkpoint.spawn_point:
			current_checkpoint = checkpoint
		
	is_dialogue_ready = false

	SaverLoader.save_game()
