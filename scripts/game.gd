extends Node

var speed: EditableInt = EditableInt.new(10)
var strength: EditableInt = EditableInt.new(20)
var width: EditableInt = EditableInt.new(3)
var duration: EditableInt = EditableInt.new(2)
var num_of_waves: EditableInt = EditableInt.new(3)


func try_game_over():
	if num_of_waves.current == 0 &&  get_tree().get_node_count_in_group("Wave") <= 1:
		print("possibly game over")
