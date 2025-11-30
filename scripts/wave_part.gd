extends RigidBody2D
class_name WavePart

@export var strength: int = Game.strength.current
@export var health: int = 30
@onready var splash: GPUParticles2D = $Splash
@export var direction: WaveGenerator.DIRECTION = WaveGenerator.DIRECTION.NORTH_EAST
@export var distance: int = 2
@export var tile_size: Vector2 = Vector2(16, 8)
@export var speed: float = 10

var start_position: Vector2

var target: Vector2
var distance_spent: int = 0
var touched_objects = []
var collision_enabled = false

func _ready():
	body_entered.connect(_on_body_entered)
	
func calculate_target():
	var direction_vec = (Vector2.UP + (Vector2.RIGHT if direction == WaveGenerator.DIRECTION.NORTH_EAST else Vector2.LEFT))
	target = global_position + direction_vec * tile_size * distance / 2
	start_position = global_position
	
func _physics_process(delta: float) -> void:
	global_position = global_position.move_toward(target, speed * delta)
	if global_position == target:
		hit()

func hit():
	var destruction_animation_tween = create_tween()
	destruction_animation_tween.tween_property(self, "scale", Vector2(0, 0), 0.15)\
	.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	destruction_animation_tween.parallel().tween_property(self, "modulate:a", 0.0, 0.15)
	destruction_animation_tween.tween_callback(splash_and_destroy)


func splash_and_destroy():
	Game.try_game_over()
	splash.restart()
	queue_free()

func _on_body_entered(body: Node) -> void:
	# There is some weird behabiour on level 4 where any wave part will destroy the tower at (0,1) directly on spawn
	# This function ensures we only collide with object close enough to the wave
	if !at_touching_distance(body.global_position, self.global_position):
		return
	if  !collision_enabled:
		return
	if not touched_objects.has(body):
		touched_objects.append(body)
		if body is Tower:
			print(body.name," ", self.name, " ", body.global_position, self.global_position)
			var touch = min(strength, health)
			var destroyed = body.damage(touch)
			if !destroyed: # The object was too strong and the wave gets destroyed
				hit()
			else:
				health -= touch
			if health <= 0:
				hit()
			
		if body.is_in_group("Boulder"):
			hit()


func at_touching_distance(a: Vector2, b: Vector2):
	var x = abs(a.x - b.x)
	var y = abs(a.y - b.y)
	print("x ", x, "y ", y)
	return x <= tile_size.x && y <= tile_size.y / 2
	

func snap_to_grid(pos: Vector2) -> Vector2:
	var half_tile = tile_size * 0.5
	
	var x: float = round((pos.x / half_tile.x + pos.y / half_tile.y) * .5)
	var y: float = round((pos.y / half_tile.y - pos.x / half_tile.x) * .5)

	return Vector2(x - y, x + y) * half_tile + Vector2(4, 0)
