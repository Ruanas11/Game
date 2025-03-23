extends Area2D
var object = null
var Type = null
var ObJ_Dict = []
var Parent = self
var JieShao 
var image
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
		if Objet.Wenpeon_status == 0:
			var tween = get_tree().create_tween()
			var Text = Objet.Fittings
			tween.set_parallel()
			tween.set_trans(1)
			tween.tween_property(JieShao, "modulate:a", 1, 0.5)
			tween.tween_property(image, "modulate:a", 1, 0.5)
			tween.tween_property(image, "position", Vector2(-942,-119), 0.5)
			tween.tween_property(image, "scale", Vector2(1,1), 0.5)
			JieShao.text = Text
		if Obj.inspect() == "Item":
			Objet.Display()
		if Obj.inspect() == "Wenpeon":
			if Objet.Wenpeon_status == 0:
				Objet.Display()
				object = Objet
			Type = "Wenpeon"
			return
		if Obj.inspect() == "fittings":
			if Objet.Wenpeon_status == 0:
				Objet.Display()
				object = Objet
			Type = "fittings"
			return
func Exited(Obj):##碰撞离开检测
	if Obj.has_method("inspect"):
		var Objet = Obj.Obj
		if Objet.Wenpeon_status == 0:
			var tween = get_tree().create_tween()
			tween.set_parallel()
			tween.set_trans(1)
			tween.tween_property(JieShao, "modulate:a", 0, 0.5)
			tween.tween_property(image, "modulate:a", 0, 0.5)
			tween.tween_property(image, "position", Vector2(0,0), 0.5)
			tween.tween_property(image, "scale", Vector2(0,0), 0.5)
		if Obj.inspect() == "Item":
			Objet.Display_Fan()
		if Obj.inspect() == "Wenpeon":
			Objet.Display_Fan()
			object = null
			Type = null
		if Obj.inspect() == "fittings":
			Objet.Display_Fan()
			object = null
			Type = null
