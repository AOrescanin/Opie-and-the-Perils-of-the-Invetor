extends Control

# **************************************************************************************************

const LEVEL_BUTTON = preload("res://scenes/UI/level_button.tscn")

@export_dir var dir_path

var buttons = []
var opie_locations = [Vector2(1340, 950), Vector2(930, 845)]

@onready var grid = $MarginContainer/VBoxContainer/GridContainer
@onready var transition = $FadeTransition/CanvasLayer/Transition
@onready var opie = $Opie

@onready var home_button = $MarginContainer/VBoxContainer/GridContainer/LevelButton
@onready var village_button = $MarginContainer/VBoxContainer/GridContainer/LevelButton2
@onready var library_button = $MarginContainer/VBoxContainer/GridContainer/LevelButton3
@onready var forrest_button = $MarginContainer/VBoxContainer/GridContainer/LevelButton4
@onready var castle_button = $MarginContainer/VBoxContainer/GridContainer/LevelButton5


func _ready():
	get_levels(dir_path)
	transition.play("fade_in")
	
# **************************************************************************************************	

func get_levels(path):
	buttons.append(home_button)
	buttons.append(village_button)
	buttons.append(library_button)
	buttons.append(forrest_button)
	buttons.append(castle_button)
	
	var index = 0
	
	for b in buttons:
		b.visible = GameManager.level_unlocked[index]
		if b.visible:
			b.grab_focus()
			opie.position = opie_locations[index]
		index += 1
		
		
	#var dir = DirAccess.open(path)
	#if dir:
		#var index = 0
		#dir.list_dir_begin()
		#var file_name = dir.get_next()
		#while file_name != "":
			##create_level_button('%s%s' % [dir.get_current_dir(), "/" + file_name], file_name, index)
			#file_name = dir.get_next().trim_suffix('.remap')
			#index += 1
		#dir.list_dir_end()
	#else:
		#print("An error occured when trying to access the path")
		
# **************************************************************************************************		

func create_level_button(level_path: String, level_name: String, level_index: int):
	var button = LEVEL_BUTTON.instantiate()
	button.visible = GameManager.level_unlocked[level_index]
	button.text	= level_name.trim_suffix('.tscn').replace('_', ' ')
	button.level_path = level_path
	button.lvl_num = level_index
	grid.add_child(button)
	buttons.append(button)
	if buttons.size() == 5:
		print(buttons)
		var index = 0
		for i in GameManager.level_unlocked:
			if i == true:
				buttons[index].grab_focus()
				opie.position = opie_locations[index]
			
			index += 1

func set_opie_position(lvl_num: int):
	opie.position = opie_locations[lvl_num]
