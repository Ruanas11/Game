extends Area2D

func Atk(Damage):
	for i in get_overlapping_areas():
		if i.has_method("Monster_hit"): #碰撞到怪物触发事件
			var aDamage = "%.1f" % Damage
			i.Monster_hit(aDamage,i.global_position)
		pass
	
