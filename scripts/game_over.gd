extends CanvasLayer


func _on_retry_pressed() -> void:
	Game.begin_level()


func _on_main_menu_pressed() -> void:
	Game.main_menu()
