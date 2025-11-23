extends Resource
class_name EditableInt

@export var current: int = 0:
	set(value):
		current = value
		emit_changed()
		
		
func _init(value: int):
	current = value
