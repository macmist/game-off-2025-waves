extends RigidBody2D
class_name WavePart


func hit():
	queue_free()


func _on_body_entered(body: Node) -> void:
	print("entered collision, ", body)
	if body is Tower:
		print("it is a tower")
		var destroyed = body.damage(20)
		print("destroyed tower? ", destroyed)
		if !destroyed: # The object was too strong and the wave gets destroyed
			hit()
		
	pass # Replace with function body.
