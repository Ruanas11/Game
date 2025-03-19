extends Area2D
var ObJ_Dict = []
func  _physics_process(delta: float) -> void:
	for i in ObJ_Dict:
		if overlaps_area(i.Detct) == false:
			i.Wenpeon_Detc = false
		if overlaps_area(i.Detct):
			i.Wenpeon_Detc = true
