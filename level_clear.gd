extends CanvasLayer
@onready var next_level: Button = $"PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Next Level"
@onready var rich_text_label: RichTextLabel = $PanelContainer/MarginContainer/VBoxContainer/RichTextLabel

func _ready() -> void:
	Game.level.changed.connect(update_next_visibility)

func _on_next_level_pressed() -> void:
	Game.next_level()


func _on_main_menu_pressed() -> void:
	Game.main_menu()
	
func update_next_visibility() -> void:
	if !Game.has_next_level():
		rich_text_label.text = "Game cleared!"
	next_level.visible = Game.has_next_level()
