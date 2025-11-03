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

@export var speed: float = 10
@export var distance: int = 2


var target: Vector2


func _ready() -> void:
	global_position = Vector2(440, 504)
	var direction_vec = (Vector2.UP + Vector2.RIGHT)
	target = global_position + direction_vec * tile_size * distance
	print(global_position, target)
	

func _physics_process(delta: float) -> void:
	global_position = global_position.move_toward(target, speed * delta)
	if global_position == target:
		explode_and_quit()
		

func snap_to_grid(pos: Vector2) -> Vector2:
	var half_tile = tile_size * 0.5
	
	var x: float = round((pos.x / half_tile.x + pos.y / half_tile.y) * .5)
	var y: float = round((pos.y / half_tile.y - pos.x / half_tile.x) * .5)

	return Vector2(x - y, x + y) * half_tile


func explode_and_quit():
	# TODO: animate wave exploding
	queue_free()
