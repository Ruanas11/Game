extends Item
class_name Wenpeon
enum 弹匣 {开关,当前容量,容量,换弹时间,换弹动画}
enum 蓄力 {开关,蓄力时长,蓄力动画,蓄力后动画,数值增加,百分比增加}
enum 双持 {开关,延迟,贴图,动作}
var pos = Vector2(0,0)
@export var Atk : Vector2 = Vector2(1,5) ##攻击力
@export var Atk_CD :float = 1.5 ##攻击冷却
@export var Atk_Combo = [0] ##多段攻击 攻击后多少游戏刻后再次攻击 1秒=60游戏刻
@export var  Atk_Aimation = "null" ##攻击动画
@export var Interrupt = false ##是否开启受到攻击时打断动画和多段攻击
@export var Rot_Speed = 0.2 ##武器旋转速度
@export var Follow_Speed = Vector2(500,15) ##武器跟随速度
@export var Range_Speed = Vector2(300,20) ##范围内武器跟随速度
@export var Stop_Speed = 10 ##停止速度
@export var Suspension = "武器动画库/null"##武器悬浮动画
@export var Magazine = [false,0,10,0.5,"通用换弹动画"] ##弹匣功能
@export var Charge_UP =[false,1.5,"武器动画库/蓄力前通用动画","武器动画库/蓄力后通用动画",20,1.0] ##蓄力功能
@export var Scaling = Vector2(1,1) ##缩放
@export var Dual_wielding = [false,0.1,"res://素材库/武器贴图/Selection 2024-09-04T12.47.06.png","武器动画库/双持射击"]
@export var Flip_v = true
@export var Flip_h = true
var Atk_add : float = 0  ##蓄力数值增加伤害
var Atk_percentage_add :float= 0 ##蓄力百分比增加伤害
var timing :float = 0
var Charge_state = false 
var Kinetic_effect = []
var Wenpeon_Detc = false
func _ready() -> void:
	super()
	Type = "Wenpeon"
	$Item.scale = Scaling
func _physics_process(delta: float) -> void:
	super(delta)
	if Wenpeon_status == 状态.背包:
		visible = false
	if Wenpeon_status == 状态.手持:
		visible = true
		var tween = get_tree().create_tween()
		tween.tween_property($Item, "rotation", $Item.rotation + $Item.get_angle_to(get_global_mouse_position()), Rot_Speed)
		var Rot = $Item.rotation
		var Rot_Remain = int(rad_to_deg(Rot)) % 360
		#武器自动旋转
		if (Rot_Remain >= 150 and Rot_Remain <= 320) :
			if Flip_v:
				$Item.scale.y = -1
			if Flip_h:
				$Item.scale.x = -1
		if (Rot_Remain >= 1 and Rot_Remain <= 149)  or (Rot_Remain >= 321 and Rot_Remain <= 359):
			$Item.scale = Vector2(1,1)
		if (Rot_Remain <= -150 and Rot_Remain >= -320):
			if Flip_h:
				$Item.scale.x = -1
			if Flip_v:
				$Item.scale.y = -1
		if (Rot_Remain <= 0 and Rot_Remain >= -149) or (Rot_Remain <= -321 and Rot_Remain >= -359):
			$Item.scale = Vector2(1,1)
func _input(event: InputEvent) -> void:
	pass
func Aimation_Stop(pos,Obj):
	var Animation_load  = $Item/Item/AnimationPlayer
	Wenpeon_status = 状态.背包
	Animation_load.stop()
func Motion(pos):
	var posa = position.direction_to(pos.position)
	velocity = velocity.move_toward(posa*Follow_Speed.x,Follow_Speed.y)
	move_and_slide()
func Stop():
	Display_Fan()
	if Wenpeon_Detc == false:
		var posa = position.direction_to(get_global_mouse_position())
		velocity = velocity.move_toward(posa*Range_Speed.x,Range_Speed.y)
	if Wenpeon_Detc:
		velocity = velocity.move_toward(Vector2.ZERO,Stop_Speed)
	move_and_slide()
func Charge_reset():
	Atk_add = 0 
	Atk_percentage_add = 0
