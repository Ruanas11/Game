extends Wenpeon
class_name Wenpeon_General
enum 换弹状态 {未换弹,正在换弹}
@export var Follow_add_Speed = Vector2(100,100)##武器攻击时加快的跟随速度
@export var Range_add_Speed = Vector2(500,100)##武器范围内攻击加快的速度
@export var Stop_add_Speed = 200
@export var Atk_Animation = "武器动画库/通用近战攻击" ##攻击动画
@export var Atk_Animation_Extra = "null" ##额外攻击动画
@export var Maga_star = 换弹状态.未换弹
var Tick = 0 #攻击计时器
var status = 悬浮状态.未达范围
var Mouse = true
var Atk_dect = true
var Follow_Speed_BF = Vector2(0,0)
var Range_Speed_BF = Vector2(0,0)
var Stop_Speed_BF = 10
enum 攻击状态 {未攻击,准备攻击,攻击}
enum 悬浮状态 {未达范围,已达范围}
func _ready() -> void:
	super()
	$Atk_CD.timeout.connect(CD_Stop)
	$Magazine.timeout.connect(Magae)
func _physics_process(delta: float) -> void:
	super(delta)
	if Wenpeon_status != 状态.手持:  ##在背包时重置武器蓄力状态
		var tween = get_tree().create_tween()
		tween.tween_property($"蓄力", "modulate:a", 0, 0.1)
		if Charge_state:
			Charge_state = false
			$Item/Item/AnimationPlayer.play(Atk_Animation)
			$Item/Item/AnimationPlayer.stop()
			timing = 0
			Tick = 0
	#蓄力后松开鼠标执行的事件
	#================================
	if Wenpeon_status == 状态.手持 and Charge_state and Input.is_action_pressed("ShuB") == false and $Item/Item/AnimationPlayer.is_playing() == false and Wenpeon_Detc:
		if timing > Charge_UP[蓄力.蓄力时长]:
			timing = Charge_UP[蓄力.蓄力时长]
		var Atk_add = timing * Charge_UP[蓄力.数值增加]
		var Atk_percentage_add = timing * Charge_UP[蓄力.百分比增加]
		$Item/Item/AnimationPlayer.play(Charge_UP[蓄力.蓄力后动画])
		Tick = 0
		Charge_state = false
		timing = 0
		var tween = get_tree().create_tween()
		tween.tween_property($"蓄力", "modulate:a", 0, Atk_CD/2)
	#================================
	if Wenpeon_status == 状态.手持 and Charge_state:#蓄力计时器
		timing += delta
		$"蓄力".value = timing / Charge_UP[蓄力.蓄力时长] * 63 + 25
	if Wenpeon_status == 状态.手持 and Magazine[弹匣.开关]:#弹匣数量显示
		Kinetic_effect[0].text = str(Magazine[弹匣.当前容量])
		Kinetic_effect[1].text =str(". ") + str(Magazine[弹匣.容量])
	if Wenpeon_Detc and Mouse == false and Atk_dect == false:#加速状态下武器进入玩家范围事件
		Follow_Speed = Follow_Speed_BF
		Range_Speed = Range_Speed_BF
		Stop_Speed = Stop_Speed_BF
		velocity = Vector2.ZERO
		Atk_dect = true
		Tick = 0
	for i in  Atk_Combo:#伤害事件
		if i == Tick and Wenpeon_status == 状态.手持:
			var Animation_load  = $Item/Item/AnimationPlayer
			if Charge_UP[蓄力.开关] == false:
				Animation_load.play(Atk_Animation)
			#Animation_load.play(Atk_Animation_Extra)
	Tick += 1
	return
func _input(event: InputEvent) -> void:
	if Wenpeon_status == 状态.手持 and Input.get_action_strength("ShuB") and Mouse:
		if Charge_UP[蓄力.开关] and Charge_state:
			return
		if Magazine[弹匣.开关] and Maga_star == 换弹状态.正在换弹:
			return
		if Magazine[弹匣.开关] and Maga_star == 换弹状态.未换弹: #处理弹匣事件
			if Magazine_HD() == "Stop":
				return
		if Charge_UP[蓄力.开关] and Charge_state == false: #攻击播放蓄力前动画
			var tween = get_tree().create_tween()
			tween.set_trans(1)
			tween.tween_property($"蓄力", "modulate:a", 1, Atk_CD/2)
			$Item/Item/AnimationPlayer.play(Charge_UP[蓄力.蓄力动画])
			$Atk_CD.start(Atk_CD)
			Charge_state = true
		$Atk_CD.start(Atk_CD)
		Tick = 0
		Mouse = false
		$Atk_CD.start(Atk_CD)
		if Wenpeon_Detc == false: #攻击时武器没有在玩家范围内进入加速状态事件
			Follow_Speed_BF = Follow_Speed 
			Follow_Speed = Follow_add_Speed
			Range_Speed_BF = Range_Speed
			Range_Speed = Range_add_Speed
			Stop_Speed_BF = Stop_Speed
			Stop_Speed = Stop_add_Speed
			Atk_dect = false
		if Wenpeon_Detc:#攻击时武器在玩家范围内事件
			$Atk_CD.start(Atk_CD)
			Charge_state = true
			Tick = 0
func CD_Stop():
	Mouse = true
func Magae(): #换弹成功执行事件 信号连接为Magazine
	Maga_star = 换弹状态.未换弹
	Magazine[弹匣.当前容量] = Magazine[弹匣.容量]
	Kinetic_effect[0].pivot_offset = Vector2(70,65)
func Magazine_HD(): #换弹综合检测事件
	if Magazine[弹匣.当前容量] <= 0: #检测弹匣小于等于0时执行事件
		$Magazine.start(Magazine[弹匣.换弹时间])
		Maga_star = 换弹状态.正在换弹
		Kinetic_effect[0].pivot_offset = Vector2(70,32.5)#设置ui字体轴心为中央
		var tween = get_tree().create_tween()#以下为ui字体执行换弹换弹动画
		tween.set_trans(1)
		tween.tween_property(Kinetic_effect[0], "modulate:a", 0, Magazine[弹匣.换弹时间]/2)
		tween.tween_property(Kinetic_effect[0], "modulate:a", 1, Magazine[弹匣.换弹时间]/2)
		var tween1 = get_tree().create_tween()
		tween1.set_trans(1)
		tween1.tween_property(Kinetic_effect[0], "scale",Vector2(0,0), Magazine[弹匣.换弹时间]/2)
		tween1.tween_property(Kinetic_effect[0], "scale",Vector2(1,1), Magazine[弹匣.换弹时间]/2)
		return "Stop"
	if Magazine[弹匣.当前容量] >= 1:#子弹大于0时执行子弹当前容量减1
		Magazine[弹匣.当前容量] -= 1
		return "Star"
