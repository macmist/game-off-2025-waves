extends Node2D

class_name WaveGenerator

enum DIRECTION {NORTH_WEST, NORTH_EAST}

@export var wave_start_north_east: PackedScene
@export var wave_start_north_west: PackedScene

@export var wave_middle: PackedScene
@export var wave_end_north_east: PackedScene
@export var wave_end_north_west: PackedScene
@export var tile_size: Vector2 = Vector2(16, 8)
@export var direction: DIRECTION = DIRECTION.NORTH_EAST
@export var offset: Vector2 = Vector2(0, 0)
@export var collision_width: float = 16.0 # tweakable collision thickness
@export var base_wave: PackedScene
@onready var level_generator: TileMapLayer = $"../LevelGenerator"

var wave_size: int = 1


var start_position: Vector2

func build_wave():
	var wave: Wave = base_wave.instantiate()
	wave_size = Game.width.current - 2 # don't take the side into consideration
	var total_tiles = Game.width.current
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
	wave.add_child(start_tile)
	points.append(start_tile.position)

	
	for i in range(wave_size):
		var mid_tile = wave_middle.instantiate()
		mid_tile.position = Vector2(offset_x * dir_x + dir_x * (i + 1) * tile_size.x / 2, offset_y + (i + 1) * tile_size.y / 2)
		wave.add_child(mid_tile)
		points.append(mid_tile.position)

	var end_tile = wave_end_north_east.instantiate() if direction == DIRECTION.NORTH_EAST else wave_end_north_west.instantiate()
	end_tile.position =  Vector2(offset_x * dir_x + dir_x * (wave_size + 1) * tile_size.x / 2, offset_y + (wave_size + 1) * tile_size.y / 2)
	wave.add_child(end_tile)
	points.append(end_tile.position)
	#_create_collision_polygon(points, wave)
	if start_position != null:
		wave.start_point = start_position
	if direction != null:
		wave.direction = direction
	wave.distance = Game.duration.current
	wave.speed = Game.speed.current
	
	level_generator.add_child(wave) # we instantiate everything on the level generator to be able to properly order by y index
	

func _on_button_pressed() -> void:
	build_wave()
	pass # Replace with function body.


func _on_marker_tile_clicked(pos: Vector2, dir: DIRECTION) -> void:
	if Game.num_of_waves.current > 0:
		start_position = pos
		direction = dir
		build_wave()
		Game.num_of_waves.current -= 1
