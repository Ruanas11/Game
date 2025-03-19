extends Area2D
var object = null
var Type = null
var ObJ_Dict = []
var Parent = self
func _ready() -> void:
	area_entered.connect(Detect)
	area_exited.connect(Exited)
func _physics_process(delta: float) -> void:
	for i in ObJ_Dict:
		if overlaps_area(i.Detct) == false:
			i.Motion(Parent)
		if overlaps_area(i.Detct):
			i.Stop()
	if overlaps_area($CharacterBody2D/Atk_CL) == false:
		$CharacterBody2D.Motion(Parent)
	if overlaps_area($CharacterBody2D/Atk_CL):
		$CharacterBody2D.Stop()
func Detect(Obj):##碰撞相交检测
	if Obj.has_method("inspect"):
		var Objet = Obj.Obj
		if Obj.inspect() == "Item":
			Objet.Display()
		if Obj.inspect() == "Wenpeon":
			if Objet.Wenpeon_status == 0:
				Objet.Display()
				object = Objet
			Type = "Wenpeon"
func Exited(Obj):##碰撞离开检测
	if Obj.has_method("inspect"):
		var Objet = Obj.Obj
		if Obj.inspect() == "Item":
			Objet.Display_Fan()
		if Obj.inspect() == "Wenpeon":
			Objet.Display_Fan()
			object = null
			Type = null
