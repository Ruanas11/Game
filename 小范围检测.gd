extends CharacterBody2D
func Motion(pos):
	var posa = global_position.direction_to(pos.position)
	velocity = velocity.move_toward(posa*1000,500)
	move_and_slide()
func Stop():
	var posa = global_position.direction_to(get_global_mouse_position())
	velocity = velocity.move_toward(posa*1000,500)
	move_and_slide()
