extends RigidBody2D
class_name WavePart

@export var strength: int = Game.strength.current
@export var health: int = 30

var touched_objects = []

func _ready():
	body_entered.connect(_on_body_entered)


func hit():
	var destruction_animation_tween = create_tween()
	destruction_animation_tween.tween_property(self, "scale", Vector2(0, 0), 0.15)\
	.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	destruction_animation_tween.parallel().tween_property(self, "modulate:a", 0.0, 0.15)
	destruction_animation_tween.tween_callback(queue_free)


func _on_body_entered(body: Node) -> void:
	if not touched_objects.has(body):
		touched_objects.append(body)
		if body is Tower:
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
