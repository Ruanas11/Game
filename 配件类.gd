extends Item
class_name fittings

func Change():
	Wenpeon_status = 状态.背包
	visible = false
func Aimation_Stop(pos,Obj):
	var Animation_load  = $Item/Item/AnimationPlayer
	Wenpeon_status = 状态.背包
	Animation_load.stop()
