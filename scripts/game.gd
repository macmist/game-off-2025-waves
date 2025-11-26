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

const MAIN_MENU_SCENE = "res://main_menu.tscn"

func try_game_over():
	if num_of_waves.current == 0 &&  get_tree().get_node_count_in_group("Wave") <= 1:
		if get_tree().get_node_count_in_group("Tower") == 0:
			level_complete.emit(level.current)
			print("yes")
		else:
			print("no")
			level_failed.emit(level.current)
			
func begin_level():
	start_level.emit(level.current)
	
func main_menu():
	get_tree().change_scene_to_file(MAIN_MENU_SCENE)

	
func next_level():
	level.current += 1
	begin_level()
	
