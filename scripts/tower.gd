extends RigidBody2D

class_name Tower


@export var size: int = 1
@export var tower_top: PackedScene
@export var tower_middle: PackedScene

@export var tile_size: Vector2 = Vector2(16, 8)

@export var resistance_per_tile: int = 10

@onready var layers: Node2D = $Layers
@onready var particles: GPUParticles2D = $Particles


var resistance: int = 10


func _ready():
	build()
	resistance = resistance_per_tile * size

func build():
	var total_tiles = size
	var total_height = total_tiles * tile_size.y / 2
	
	for i in range(size):
		var middle = tower_middle.instantiate()
		middle.position = Vector2(0, - i * tile_size.y / 2)
		layers.add_child(middle)
		
	var top = tower_top.instantiate()
	top.position = Vector2(0, -total_height)
	layers.add_child(top)

	
func _update_collision_shape() -> void:
	var collisions = find_children("*", "CollisionShape2D")
	if collisions.size() > 0:
		var col = collisions[0];
		var shape = RectangleShape2D.new()
		shape.size.x = 8
		shape.size.y = 4
		col.shape = shape
		col.position.y = 4
		col.position.x = 0
		
		
func play_hit_shake(callback: Callable):
	var tw = create_tween()
	particles.restart()
	tw.tween_property(self, "position:x", position.x + 2, 0.05)
	tw.tween_property(self, "position:x", position.x - 2, 0.1)
	tw.tween_property(self, "position:x", position.x, 0.05)
	tw.tween_callback(callback)

# Return true if destroyed
func remove_layers(layers_to_remove: int = 1) -> bool:
	if size <= layers_to_remove:
		play_hit_shake(queue_free)
		Game.points_remaining.current += 1
		return true
	var count = layers.get_child_count()
	for i in range(layers_to_remove):
		layers.remove_child(layers.get_child(0))

	for i in range(count - layers_to_remove):
		var child = layers.get_child(i)
		child.position = Vector2(0, - i * tile_size.y / 2)
	size -= layers_to_remove
	play_hit_shake(_update_collision_shape)
	return false
	
	


func damage(amount: int) -> bool:
	var layers_to_remove = 0
	while amount > 0:
		var a = resistance % resistance_per_tile
		if a > 0:
			resistance -= a
			amount -= a
			layers_to_remove += 1
		else:
			layers_to_remove +=  amount / resistance_per_tile
			resistance -= amount
			amount -= amount
	if layers_to_remove > 0:
		return remove_layers(layers_to_remove)
		
	return false
