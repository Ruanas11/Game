extends CharacterBody2D
class_name  blood_volume
@export var Volume : float = 100 

func _ready() -> void:
	$Monster_hit.Obj = self
	$"血条".max_value = Volume
func Monster_hit(Damage,pos):
	var Atk_Shuzi = load("res://杂项场景/伤害数字场景.tscn").instantiate()
	Atk_Shuzi.Damage_int = Damage
	Atk_Shuzi.global_position = pos
	Atk_Shuzi.position.x += randf_range(-5,5)
	Atk_Shuzi.position.y += randf_range(-5,5)
	Volume -= float(Damage)
	$"血条".value = Volume
	get_parent().add_child(Atk_Shuzi)
	pass
