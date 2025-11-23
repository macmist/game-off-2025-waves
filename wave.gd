extends Node2D

class_name Wave

@export var wave_size: int = 1

@export var tile_size: Vector2 = Vector2(16, 8)
@export var direction: WaveGenerator.DIRECTION = WaveGenerator.DIRECTION.NORTH_EAST
@export var offset: Vector2 = Vector2(0, 0)
@export var collision_width: float = 16.0 # tweakable collision thickness

@export var speed: float = 10
@export var distance: int = 2
@export var start_point: Vector2 = Vector2(440, 504)

var target: Vector2


func _ready() -> void:
	global_position = start_point
	var direction_vec = (Vector2.UP + (Vector2.RIGHT if direction == WaveGenerator.DIRECTION.NORTH_EAST else Vector2.LEFT))
	target = global_position + direction_vec * tile_size * distance / 2
	print(global_position, target)
	

func _physics_process(delta: float) -> void:
	global_position = global_position.move_toward(target, speed * delta)
	if global_position == target:
		explode_and_quit()
		



func explode_and_quit():
	Game.try_game_over()
	queue_free()
