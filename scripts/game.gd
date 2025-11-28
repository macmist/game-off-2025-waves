extends Node

signal level_complete(level_number: int)
signal level_failed(level_number: int)
signal start_level(level_number: int)


var speed: EditableInt = EditableInt.new(10)
var strength: EditableInt = EditableInt.new(20)
var width: EditableInt = EditableInt.new(3)
var duration: EditableInt = EditableInt.new(2)
var num_of_waves: EditableInt = EditableInt.new(3)
var points_remaining: EditableInt = EditableInt.new(0)
var level: EditableInt = EditableInt.new(0)
var max_level: EditableInt = EditableInt.new(0)

const MAIN_MENU_SCENE = "res://scenes/main_menu.tscn"

func try_game_over():
	if num_of_waves.current == 0 &&  get_tree().get_node_count_in_group("Wave") <= 1:
		if get_tree().get_node_count_in_group("Tower") == 0:
			level_complete.emit(level.current)
		else:
			level_failed.emit(level.current)
			
func begin_level():
	start_level.emit(level.current)
	
func main_menu():
	get_tree().change_scene_to_file(MAIN_MENU_SCENE)

func has_next_level():
	return level.current < max_level.current
	
func next_level():
	if level.current < max_level.current:
		level.current += 1
		begin_level()
	
func find_all_levels():
	var dir = DirAccess.open("res://levels")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir():
				if file_name.begins_with("level_"):
					var level_number_str = file_name.substr("level_".length(), -1).replace(".txt", "")
					if level_number_str.is_valid_int():
						var level_number = int(level_number_str)
						if level_number > max_level.current:
							max_level.current = level_number
			file_name = dir.get_next()
	
	else:
		print("no dir")
