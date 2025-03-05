extends Wenpeon
class_name Wenpeon_LongRange
enum 换弹状态 {未换弹,正在换弹}
enum 投掷功能 {投掷开关,蓄力关联,增加力度,重力}
@export var Bullet = load("res://道具类/远程武器场景/子弹场景/通用子弹场景.tscn") ##子弹场景
@export var Bullet_Textu = load("res://素材库/武器贴图/Selection 2024-09-04T01.09.08.png") ##子弹贴图
@export var Bullet_speed = Vector2(1000,1000) ##子弹基础速度
@export var Bullet_add_speed = Vector2(0,0) ##子弹加速度
@export var Bullet_Qty = Vector2(1,1) ##单次武器发射的子弹数量
@export var Bullet_Scatter = Vector2(1,-1) ##子弹散射角度
@export var Launch_pos = Vector2(0,0)##子弹发射位置
@export var Atk_Animation = "武器动画库/通用射击动画" ##攻击动画
@export var Atk_Animation_Extra = "null" ##额外攻击动画
@export var Throwables = [false,false,0.1,0.1] ##投掷/子弹重力系统
@export var Kill_CD = Vector2(1,2)
@export var Maga_star = 换弹状态.未换弹
var Tick = 0 #攻击计时器
var Mouse = true
var Atk_dect = true
var Rota = 0
var Posa = Vector2.ZERO
var gravity = 0
func _ready() -> void:
	super()
	$Atk_CD.timeout.connect(CD_Stop)
	$Magazine.timeout.connect(Magae)
func _physics_process(delta: float) -> void:
	super(delta)
	if Wenpeon_status != 状态.手持:#武器不为手持时退出蓄力状态
		var tween = get_tree().create_tween()
		tween.tween_property($"蓄力", "modulate:a", 0, 0.1)
		if Charge_state:
			Charge_state = false
			$Item/Item/AnimationPlayer.play(Atk_Animation)
			$Item/Item/AnimationPlayer.stop()
			timing = 0
			Tick = 0
	if Wenpeon_status == 状态.手持 and Charge_state:#蓄力计时器
		timing += delta
		$"蓄力".value = timing / Charge_UP[蓄力.蓄力时长] * 63 + 25
	#蓄力状态下松开鼠标执行的事件
	#========================================
	if Wenpeon_status == 状态.手持 and Charge_state and Input.is_action_pressed("ShuB") == false and $Item/Item/AnimationPlayer.is_playing() == false :
		if timing > Charge_UP[蓄力.蓄力时长]:#根据蓄力时长设置伤害
			timing = Charge_UP[蓄力.蓄力时长]
		var percentage = timing  / Charge_UP[蓄力.蓄力时长]
		var Atk_add = percentage * Charge_UP[蓄力.数值增加]
		var Atk_percentage_add = percentage * Charge_UP[蓄力.百分比增加] / 100 * Atk
		if Throwables[投掷功能.投掷开关] and Throwables[投掷功能.蓄力关联]:
			gravity = percentage * Throwables[投掷功能.增加力度]
		$Item/Item/AnimationPlayer.play(Charge_UP[蓄力.蓄力后动画]) #蓄力条
		var tween = get_tree().create_tween()
		tween.tween_property($"蓄力", "modulate:a", 0, Atk_CD/2)
		Tick = 0
		Charge_state = false
		timing = 0
	#========================================
	if Wenpeon_status == 状态.手持: #弹匣ui显示
		Kinetic_effect[0].text = str(Magazine[弹匣.当前容量])
		Kinetic_effect[1].text =str(". ") + str(Magazine[弹匣.容量])
	if Wenpeon_status == 状态.手持 and Input.is_action_pressed("ShuB")  and Mouse:#武器攻击时事件
		if Charge_UP[蓄力.开关] and Charge_state:
			return
		if Magazine[弹匣.开关] and Maga_star == 换弹状态.正在换弹:
			return
		if Magazine[弹匣.开关] and Maga_star == 换弹状态.未换弹: #弹匣事件
			if Magazine_HD() == "Stop":
				return
		if Charge_UP[蓄力.开关] and Charge_state == false:#蓄力事件
			Charge_time()
			Mouse = false
			$Atk_CD.start(Atk_CD)
			return
		Mouse = false
		$Atk_CD.start(Atk_CD)
		Tick = 0
	Rota = $Item.rotation_degrees
	Posa = $Item/pos.global_position
	for i in  Atk_Combo: #伤害执行器
		if i == Tick and Wenpeon_status == 状态.手持:
			var Animation_load  = $Item/Item/AnimationPlayer
			if Charge_UP[蓄力.开关] == false: #当武器拥有蓄力功能时关闭默认动画
				Animation_load.stop()
				Animation_load.play(Atk_Animation)
			var tween = get_tree().create_tween()
			tween.set_trans(1)
			tween.tween_property(Kinetic_effect[0], "scale", Vector2(1.5,1.5), Atk_CD/1.5) #字体动画
			tween.tween_property(Kinetic_effect[0], "scale", Vector2(1,1), Atk_CD/1.5)
			#Animation_load.play(Atk_Animation_Extra)
			for x in randi_range(Bullet_Qty.x,Bullet_Qty.y): #子弹生成
				if Throwables[投掷功能.投掷开关] == false:
					var Bullet_ins = Bullet.instantiate()
					Bullet_ins.Speed = randi_range(Bullet_speed.x,Bullet_speed.y)
					Bullet_ins.rotation_degrees = Rota + randf_range(Bullet_Scatter.x,Bullet_Scatter.y)
					Bullet_ins.Text = Bullet_Textu
					Bullet_ins.position = Posa
					get_parent().add_child(Bullet_ins)
					Bullet_ins.kill(randf_range(Kill_CD.x,Kill_CD.y))
				if Throwables[投掷功能.投掷开关]: #投掷/重力功能开启事件
					var Bullet_ins = load("res://道具类/远程武器场景/子弹场景/投掷物场景.tscn").instantiate()
					match Throwables[投掷功能.蓄力关联]:
						true:
							Bullet_ins.gravity = Throwables[投掷功能.重力] - gravity
						false:
							Bullet_ins.gravity = Throwables[投掷功能.重力]
					Bullet_ins.Speed = randi_range(Bullet_speed.x,Bullet_speed.y)
					Bullet_ins.rotation_degrees = Rota + randf_range(Bullet_Scatter.x,Bullet_Scatter.y)
					Bullet_ins.Text = Bullet_Textu
					Bullet_ins.position = Posa
					get_parent().add_child(Bullet_ins)
					Bullet_ins.kill(randf_range(Kill_CD.x,Kill_CD.y))
	Tick += 1
	return
func _input(event: InputEvent) -> void:
	pass
func CD_Stop():
	Mouse = true
func Magae(): #换弹后事件
	Maga_star = 换弹状态.未换弹
	Magazine[弹匣.当前容量] = Magazine[弹匣.容量]
	Kinetic_effect[0].pivot_offset = Vector2(70,65)
func Magazine_HD():#弹匣综合执行事件
	if Magazine[弹匣.当前容量] <= 0:#子弹小于等于0时执行的事件
		$Magazine.start(Magazine[弹匣.换弹时间])  #设置计时器 用于启动换弹后事件
		Maga_star = 换弹状态.正在换弹
		Kinetic_effect[0].pivot_offset = Vector2(70,32.5) #设置ui字体轴心
		var tween = get_tree().create_tween()
		tween.set_trans(1)#ui字体换弹动画
		tween.tween_property(Kinetic_effect[0], "modulate:a", 0, Magazine[弹匣.换弹时间]/2)
		tween.tween_property(Kinetic_effect[0], "modulate:a", 1, Magazine[弹匣.换弹时间]/2)
		var tween1 = get_tree().create_tween()
		tween1.set_trans(1)
		tween1.tween_property(Kinetic_effect[0], "scale",Vector2(0,0), Magazine[弹匣.换弹时间]/2)
		tween1.tween_property(Kinetic_effect[0], "scale",Vector2(1,1), Magazine[弹匣.换弹时间]/2)
		return "Stop"
	if Magazine[弹匣.当前容量] >= 1:
		Magazine[弹匣.当前容量] -= 1
		return "Star"
func Charge_time(): #蓄力事件
	var tween = get_tree().create_tween()
	tween.set_trans(1)
	tween.tween_property($"蓄力", "modulate:a", 1, Atk_CD/2) #蓄力条
	Charge_state = true
	$Item/Item/AnimationPlayer.play(Charge_UP[蓄力.蓄力动画])
	return true
	
	
