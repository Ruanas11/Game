extends CharacterBody2D
class_name Item
var Type = "Item"
enum 状态 {掉落物,手持,背包,投掷物}
@export var Textu = load("res://素材库/武器贴图/A3.png")
@export var Donghua = "武器动画库/null" ##动画id
@export var LV = 0 ##等级
@export var text = "未命名"##名称
@export var Text_pos = Vector2(0,0)##名称定位
@export var Qty = 1##数量
@export var Wenpeon_status = 状态.掉落物 ##武器状态 分为掉落物  手持  背包内
@export var Fittings = ""
@export var Item_Type = "Item"
var Detct 
func _ready() -> void:
	var Animation_load  = $Item/Item/AnimationPlayer
	$Item/Item.texture = Textu
	Detct = $Type
	Animation_load.play(Donghua)
	match LV:
		0:
			$Label.label_settings.font_color = Color(0,1,0,1)
		1:
			$Label.label_settings.font_color = Color(0,1,1,1)
		2:
			$Label.label_settings.font_color = Color(1,0,1,1)
		3:
			$Label.label_settings.font_color = Color(1,1,0,1)
		4:
			$Label.label_settings.font_color = Color(1,0,0,1)
	$Label.position = Text_pos
	$Label.text = text
func _physics_process(delta: float) -> void:
	$Type.Obj = self
	if Qty == 0 :
		queue_free()
func Display():
	var tween = get_tree().create_tween()
	tween.tween_property($Label, "modulate:a", 1, 0.5)
func Display_Fan():
	var tween = get_tree().create_tween()
	tween.tween_property($Label, "modulate:a", 0, 0.5)
