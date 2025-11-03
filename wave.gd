extends Node2D
enum DIRECTION {NORTH_WEST, NORTH_EAST}

@export var wave_size: int = 1
@export var wave_start_north_east: PackedScene
@export var wave_start_north_west: PackedScene

@export var wave_middle: PackedScene
@export var wave_end_north_east: PackedScene
@export var wave_end_north_west: PackedScene
@export var tile_size: Vector2 = Vector2(16, 8)
@export var direction: DIRECTION = DIRECTION.NORTH_EAST
@export var offset: Vector2 = Vector2(0, 0)
@export var collision_width: float = 16.0 # tweakable collision thickness


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
	
	var dir_x := 1.0 if direction == DIRECTION.NORTH_EAST else -1.0
	
	var points: Array[Vector2] = []
	
	var start_tile = wave_start_north_east.instantiate() if direction == DIRECTION.NORTH_EAST else wave_start_north_west.instantiate()
	start_tile.position = Vector2(offset_x * dir_x, offset_y)
	$Tiles.add_child(start_tile)
	points.append(start_tile.position)

	
	for i in range(wave_size):
		var mid_tile = wave_middle.instantiate()
		mid_tile.position = Vector2(offset_x * dir_x + dir_x * (i + 1) * tile_size.x / 2, offset_y + (i + 1) * tile_size.y / 2)
		$Tiles.add_child(mid_tile)
		points.append(mid_tile.position)

	var end_tile = wave_end_north_east.instantiate() if direction == DIRECTION.NORTH_EAST else wave_end_north_west.instantiate()
	end_tile.position =  Vector2(offset_x * dir_x + dir_x * (wave_size + 1) * tile_size.x / 2, offset_y + (wave_size + 1) * tile_size.y / 2)
	$Tiles.add_child(end_tile)
	points.append(end_tile.position)
	_create_collision_polygon(points, dir_x)
	
	
func _create_collision_polygon(points: Array[Vector2], dir_x: float) -> void:
	if points.is_empty():
		return

	var half_w = collision_width / 2.0

	# The polygon will be built along the tile line, offset perpendicular by half width
	var poly_points: Array[Vector2] = []

	# Compute perpendicular vector for width offset
	var step_vec = (points[-1] - points[0]).normalized()
	var perp_vec = Vector2(-step_vec.y, step_vec.x) * half_w

	# Build top and bottom edges
	for p in points:
		poly_points.append(p + perp_vec)
	points.reverse()
	for p in points:
		poly_points.append(p - perp_vec)
		
	var poly = CollisionPolygon2D.new()
	poly.polygon = poly_points
	add_child(poly)

func _physics_process(delta: float) -> void:
	global_position = snap_to_grid(get_global_mouse_position()) + Vector2(8, 8)

func snap_to_grid(pos: Vector2) -> Vector2:
	var half_tile = tile_size * 0.5
	
	var x: float = round((pos.x / half_tile.x + pos.y / half_tile.y) * .5)
	var y: float = round((pos.y / half_tile.y - pos.x / half_tile.x) * .5)

	return Vector2(x - y, x + y) * half_tile
