extends RigidBody2D
class_name WavePart

@export var strength: int = Game.strength.current
@export var health: int = 30

func _ready():
	body_entered.connect(_on_body_entered)


func hit():
	queue_free()


func _on_body_entered(body: Node) -> void:
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
