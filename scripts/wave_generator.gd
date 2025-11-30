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
	wave_size = Game.width.current - 2 # don't take the side into consideration
	var total_tiles = Game.width.current
	# instantiate enough middle tile
	# based on wave size
	var total_size = total_tiles * tile_size
	
	var offset_x = -total_size.x / 4 + tile_size.x / 4
	var offset_y = -total_size.y / 4 + tile_size.y / 4
	
	var dir_x := 1.0 if direction == DIRECTION.NORTH_EAST else -1.0
	
	var start_tile: WavePart = wave_start_north_east.instantiate() if direction == DIRECTION.NORTH_EAST else wave_start_north_west.instantiate()
	level_generator.add_child(start_tile)
	start_tile.global_position = start_position +  Vector2(offset_x * dir_x, offset_y)
	start_tile.distance = Game.duration.current
	start_tile.speed = Game.speed.current
	start_tile.direction = direction
	start_tile.calculate_target()
	
	for i in range(wave_size):
		var mid_tile: WavePart = wave_middle.instantiate()
		level_generator.add_child(mid_tile)
		mid_tile.global_position = start_position + Vector2(offset_x * dir_x + dir_x * (i + 1) * tile_size.x / 2, offset_y + (i + 1) * tile_size.y / 2)
		mid_tile.speed = Game.speed.current
		mid_tile.direction = direction
		mid_tile.distance = Game.duration.current
		mid_tile.calculate_target()
		
	var end_tile: WavePart = wave_end_north_east.instantiate() if direction == DIRECTION.NORTH_EAST else wave_end_north_west.instantiate()
	level_generator.add_child(end_tile)
	end_tile.global_position = start_position + Vector2(offset_x * dir_x + dir_x * (wave_size + 1) * tile_size.x / 2, offset_y + (wave_size + 1) * tile_size.y / 2)
	end_tile.distance = Game.duration.current
	end_tile.speed = Game.speed.current
	end_tile.direction = direction
	end_tile.calculate_target()
		
	for x in level_generator.get_children():
		if x is WavePart:
			x.collision_enabled = true
	

func _on_button_pressed() -> void:
	build_wave()
	pass # Replace with function body.


func _on_marker_tile_clicked(pos: Vector2, dir: DIRECTION) -> void:
	if Game.num_of_waves.current > 0:
		start_position = pos
		direction = dir
		build_wave()
		Game.num_of_waves.current -= 1
