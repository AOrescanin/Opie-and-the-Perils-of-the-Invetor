extends Node

# **************************************************************************************************

func create_new_save(slot_num: int):
	var saved_game:SavedGame = SavedGame.new()
	
	saved_game.slot_num = slot_num
	saved_game.levels_completed = GameManager.level_completed
	saved_game.levels_unlocked = GameManager.level_unlocked
	
	ResourceSaver.save(saved_game, "user://savegame" + str(slot_num) + ".tres")
	
# **************************************************************************************************

func save_game():
	var saved_game:SavedGame = SavedGame.new()
	
	saved_game.slot_num = 1
	saved_game.in_level = GameManager.in_level
	saved_game.level_num = GameManager.level_num
	GameManager.player_positions[GameManager.level_num] = GameManager.current_checkpoint.position
	saved_game.player_position = GameManager.player_positions
	saved_game.levels_completed = GameManager.level_completed
	saved_game.levels_unlocked = GameManager.level_unlocked
	
	ResourceSaver.save(saved_game, "user://savegame1.tres")
	
# **************************************************************************************************
	
func load_game(level_select: bool, lvl_num: int):
	var saved_game:SavedGame = load("user://savegame1.tres") as SavedGame
	
	GameManager.in_level = saved_game.in_level
	if(level_select):
		GameManager.level_num = lvl_num
	else:
		GameManager.level_num = saved_game.level_num
	print(GameManager.level_num)
	print("^game")
	print(saved_game.player_position[GameManager.level_num])
	GameManager.player_positions = saved_game.player_position
	GameManager.player_position = saved_game.player_position[GameManager.level_num]
	GameManager.level_completed = saved_game.levels_completed
	GameManager.level_unlocked = saved_game.levels_unlocked

	
