extends Line2D
var Shu = 10
func _physics_process(delta: float) -> void:
	global_position = Vector2.ZERO
	global_rotation = 0
	if get_point_count() < Shu:
		add_point($"..".global_position)
	if get_point_count() >= Shu:
		remove_point(0)
