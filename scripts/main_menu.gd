extends CanvasLayer

@onready var level_selection_container: MarginContainer = $"Control/LevelSelection Container"
@onready var back: Button = $"Control/LevelSelection Container/PanelContainer/MarginContainer/VBoxContainer/Back"
@onready var level_list: GridContainer = $"Control/LevelSelection Container/PanelContainer/MarginContainer/VBoxContainer/Level list"


const GAME_SCENE = "res://scenes/game_scene.tscn"


func _ready() -> void:
	Game.find_all_levels()
	fill_levels()

func fill_levels() -> void:
	for i in range(Game.max_level.current + 1):
		var button = Button.new()
		button.text = str(i)
		button.pressed.connect(start_level.bind(i))
		level_list.add_child(button)

func _on_choose_level_pressed() -> void:
	level_selection_container.visible = true


func _on_back_pressed() -> void:
	level_selection_container.visible = false


func _on_start_pressed() -> void:
	start_level(0)
	
func start_level(level: int) -> void:
	Game.level.current = level
	get_tree().change_scene_to_file(GAME_SCENE)
