extends Node2D

const GAME_SCENE = "res://game_scene.tscn"

func _on_start_pressed() -> void:
	Game.level.current = 0
	get_tree().change_scene_to_file(GAME_SCENE)
