extends CanvasLayer

@onready var bottom_menu: HBoxContainer = $"MarginContainer/PanelContainer/MarginContainer/Bottom Menu"

const TEXT_WITH_BUTTON = preload("res://text_with_button.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_bottom_button("speed", 10, Game.speed)
	add_bottom_button("strength", 1, Game.strength)
	add_bottom_button("width", 2, Game.width)
	add_bottom_button("duration", 1, Game.duration)
	
	
	
func add_bottom_button(text: String, increment_value: int, value: EditableInt):
	var button = TEXT_WITH_BUTTON.instantiate()
	button.value_text = text
	button.editable_value = value
	button.button_increment = increment_value
	bottom_menu.add_child(button)
