extends Node2D

@onready var game_over: CanvasLayer = $"Game Over"
@onready var level_clear: CanvasLayer = $"Level Clear"
@onready var in_game_menu: CanvasLayer = $InGameMenu
@onready var level_generator: LevelGenerator = $LevelGenerator

func _ready() -> void:
	Game.start_level.connect(load_level)
	Game.level_complete.connect(show_level_clear)
	Game.level_failed.connect(show_game_over)
	
	
func load_level(level_number: int):
	level_generator.setup(level_number)
	in_game_menu.visible = true
	game_over.visible = false
	level_clear.visible = false
	

func show_level_clear(level_number: int):
	in_game_menu.visible = false
	game_over.visible = false
	level_clear.visible = true
	
func show_game_over(level_number: int):
	in_game_menu.visible = false
	game_over.visible = true
	level_clear.visible = false
