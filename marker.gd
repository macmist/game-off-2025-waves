extends Sprite2D

@export var tile_size: Vector2 = Vector2(16, 8)
@export var floor_map: FloorMap
var current_tile_type: String = ""

signal tile_clicked(position: Vector2, direction: WaveGenerator.DIRECTION)

func _physics_process(delta: float) -> void:
	global_position = snap_to_grid(get_global_mouse_position()) + Vector2(4, -2)
	if floor_map:
		var type = floor_map.get_tile_type(global_position)
		current_tile_type = type
		if type.contains("border"):
			modulate = Color(0, 1, 0)
		else:
			modulate = Color(1, 0, 0)
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT && current_tile_type.contains("border"):
		var direction = WaveGenerator.DIRECTION.NORTH_WEST if current_tile_type.contains("NW") else WaveGenerator.DIRECTION.NORTH_EAST
		tile_clicked.emit(global_position + Vector2(2, -4), direction) # centering the tile

func snap_to_grid(pos: Vector2) -> Vector2:
	var half_tile = tile_size * 0.5
	
	var x: float = round((pos.x / half_tile.x + pos.y / half_tile.y) * .5)
	var y: float = round((pos.y / half_tile.y - pos.x / half_tile.x) * .5)

	return Vector2(x - y, x + y) * half_tile
