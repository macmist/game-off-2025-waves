extends Sprite2D

@export var tile_size: Vector2 = Vector2(16, 8)

signal tile_clicked(position: Vector2)

func _physics_process(delta: float) -> void:
	global_position = snap_to_grid(get_global_mouse_position())
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		tile_clicked.emit(global_position + Vector2(0, -4))

func snap_to_grid(pos: Vector2) -> Vector2:
	var half_tile = tile_size * 0.5
	
	var x: float = round((pos.x / half_tile.x + pos.y / half_tile.y) * .5)
	var y: float = round((pos.y / half_tile.y - pos.x / half_tile.x) * .5)

	return Vector2(x - y, x + y) * half_tile
