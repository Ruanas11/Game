extends Area2D
var Damage = 0
var Obj
var Penet
func _ready() -> void:
	area_entered.connect(Hit)
func free() -> void:
	pass
func Hit(Type):
	if Type.has_method("Monster_hit"): #碰撞到怪物触发事件
		Type.Monster_hit(Damage,global_position)
		Penet -= 1
		if Penet <= 0:
			Obj.queue_free()
		pass
