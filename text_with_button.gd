extends VSplitContainer

class_name TextWithButton

@onready var value: RichTextLabel = $"Value Text"
@onready var button: Button = $Button

@export var value_text: String = "Some data"
@export var button_increment: int = 1
@export var editable_value: EditableInt:
	set(value):
		editable_value = value
		editable_value.changed.connect(_update_displays)

@export var enabled: bool = false:
	set(value):
		enabled = value
		button.disabled = !value
		
signal clicked

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_displays()

func _update_displays():
	value.text = str(value_text)
	if editable_value:
		value.text = str(value_text) + ": " + str(editable_value.current)
	button.text = "+" + str(button_increment)
	


func _on_button_pressed() -> void:
	editable_value.current += button_increment
	clicked.emit()
