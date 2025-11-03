extends Node2D
enum DIRECTION {NORTH_WEST, NORTH_EAST}

@export var wave_size: int = 1
@export var wave_start: PackedScene
@export var wave_middle: PackedScene
@export var wave_end: PackedScene
@export var tile_size: Vector2 = Vector2(16, 8)
@export var direction: DIRECTION = DIRECTION.NORTH_EAST
@export var offset: Vector2 = Vector2(0, -5)


func _ready() -> void:
	build_wave()

func build_wave():
	for child in $Tiles.get_children():
		child.queue_free()
	
	var total_tiles = wave_size + 2
	# instantiate enough middle tile
	# based on wave size
	var total_size = total_tiles * tile_size
	
	# TODO: handle correct offset when direction is north west
	var offset_x = -total_size.x / 4 + tile_size.x / 4
	var offset_y = -total_size.y / 4 + tile_size.y / 4
	
	var start_tile = wave_start.instantiate() if direction == DIRECTION.NORTH_WEST else wave_end.instantiate()
	start_tile.position = Vector2(offset_x, offset_y)
	$Tiles.add_child(start_tile)

	
	for i in range(wave_size):
		var mid_tile = wave_middle.instantiate()
		mid_tile.position = Vector2(offset_x + (i + 1) * tile_size.x / 2, offset_y + (i + 1) * tile_size.y / 2)
		$Tiles.add_child(mid_tile)

	var end_tile = wave_end.instantiate() if direction == DIRECTION.NORTH_WEST else wave_start.instantiate()
	end_tile.position =  Vector2(offset_x + (wave_size + 1) * tile_size.x / 2, offset_y + (wave_size + 1) * tile_size.y / 2)
	$Tiles.add_child(end_tile)
	

func _physics_process(delta: float) -> void:
	global_position = snap_to_grid(get_global_mouse_position()) + offset

func snap_to_grid(pos: Vector2) -> Vector2:
	var half_tile = tile_size * 0.5
	
	var x: float = round((pos.x / half_tile.x + pos.y / half_tile.y) * .5)
	var y: float = round((pos.y / half_tile.y - pos.x / half_tile.x) * .5)

	return Vector2(x - y, x + y) * half_tile
