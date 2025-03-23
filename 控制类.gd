extends CharacterBody2D
enum 状态 {掉落物,手持,背包}
var Volume_Max :float =  200 ##最大血量
var Volume :float = 200 ##当前血量
var SPEED = 400##最大速度
var ADD_SPEED = 100 ##加速度
var MOCha = 700 ##摩擦系数
var UP = -1000 ##基础弹跳
var Down = 2000 ##重力
var Kong = true ##空格检测
var Add_UP = -1000 ##长按向上加的向量
var Add_UP_time = 0.4 ##长按最长时间
var Donghua = true ##动画检测 
var DiMian = true ##地面检测
var tween_st ##血条动画储存
var Wenpeon_Qty_Max = 3 ##最多装备武器数量
var Wenpeon_Qty = 0 ##当前装备武器数量
var Wenpeon_Held = 0 ##当前手持武器槽位id
var Wenpeon_Dict = [] ##当前装备的武器词典
func _ready() -> void:
	$Area2D.JieShao = $"画布/UI/介绍/RichTextLabel"
	$Area2D.image = $"画布/UI/介绍"
	$"画布/UI/配件系统/ItemList".item_clicked.connect(Kna_click)
func _input(event: InputEvent) -> void:
	$Area2D.Parent = self
	#if Input.get_action_strength("ShuB"):##血条实验功能
	#	Volume_re()
	if Input.is_action_pressed("背包"): ##背包界面
		Knapsack_Display()
	if Input.get_action_strength("拾取") and $Area2D.object != null:
		if $Area2D.object.Wenpeon_status == 0  and  $Area2D.object.Item_Type == "Fittings":
			Tween_Down()
			$"画布/UI/配件系统/ItemList".Add_to($Area2D.object)
			return
		if $Area2D.object.Wenpeon_status == 0  and $Area2D.object.Item_Type == "Wenpeon" and  Wenpeon_Qty < Wenpeon_Qty_Max: #检测武器状态是否为掉落物/道具类型是否为武器/武器装备数量是否小于武器最大装备数量
			$Area2D.object.Aimation_Stop(position,self)#执行武器对象事件
			#=============================================================== 执行介绍面板消失
			Tween_Down()
			#====================================================================
			$Area2D.ObJ_Dict.append($Area2D.object)#将对象添加到范围检测节点的检测词典中
			$Area2D.object.Kinetic_effect.append($"画布/UI/弹匣/前")
			$Area2D.object.Kinetic_effect.append($"画布/UI/弹匣/后")
			Wenpeon_Dict.append($Area2D.object)#将对象添加到武器词典中
			Wenpeon_Qty += 1#当前武器数量+1
			if Wenpeon_Held >= 1:
				Wenpeon_Dict[Wenpeon_Held - 1].Wenpeon_status = 状态.背包
			Wenpeon_Held += 1
			Wenpeon_Dict[Wenpeon_Held - 1].Wenpeon_status = 状态.手持 #把当前手持武器的状态设置为手持
			Tween_Switch()
			return
	if Input.get_action_strength("滚轮上") and Wenpeon_Qty >= 2:
		var Tempor = Wenpeon_Dict[Wenpeon_Held - 1]
		Wenpeon_Dict[Wenpeon_Held - 1].Wenpeon_status = 状态.背包
		Wenpeon_Held += 1
		if Wenpeon_Held > Wenpeon_Qty:
			Wenpeon_Held = 1
		Wenpeon_Dict[Wenpeon_Held - 1].position = Tempor.position
		Wenpeon_Dict[Wenpeon_Held - 1].Wenpeon_status = 状态.手持 #把当前手持武器的状态设置为手持
		Tween_Switch()
	if Input.get_action_strength("滚轮下") and Wenpeon_Qty >= 2:
		var Tempor = Wenpeon_Dict[Wenpeon_Held - 1]
		Wenpeon_Dict[Wenpeon_Held - 1].Wenpeon_status = 状态.背包
		Wenpeon_Held -= 1
		if Wenpeon_Held <= 0:
			Wenpeon_Held = Wenpeon_Qty
		Wenpeon_Dict[Wenpeon_Held - 1].position = Tempor.position
		Wenpeon_Dict[Wenpeon_Held - 1].Wenpeon_status = 状态.手持 #把当前手持武器的状态设置为手持
		Tween_Switch()
func _physics_process(delta: float) -> void:
	var ShuRu_Input = Vector2.ZERO
	if (is_on_floor() or is_on_wall()) and Input.is_action_pressed("Kong") and Kong: #重置跳跃次数
		Jummp()
		velocity.y = UP
		Kong = false
		DiMian = true
	if is_on_floor() and DiMian and Kong :
		Jummp()
		DiMian = false
	if Kong == false and Add_UP_time >= 0:  #长按跳跃加y向量
		velocity.y += Add_UP * delta
		Add_UP_time -= delta
	if Input.get_action_strength("Kong") == 0: #重置长按跳跃时间
		Kong = true
		Add_UP_time = 0.4
	ShuRu_Input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")#获取input向量
	if ShuRu_Input.x != 0 :
		$AnimatedSprite2D.play("走路_中")
		var Vea = velocity.move_toward(ShuRu_Input * SPEED,ADD_SPEED) #计算加速度
		velocity.x = Vea.x
		if ShuRu_Input.x >0: #根据向量调整动画朝向
			$AnimatedSprite2D.flip_h = false
		if ShuRu_Input.x < 0:
			$AnimatedSprite2D.flip_h = true
	if ShuRu_Input.x == 0:
		$AnimatedSprite2D.play("正常")
		var Vea = velocity.move_toward(Vector2.ZERO,MOCha * delta)
		velocity.x = Vea.x
		
	velocity.y += Down * delta
	move_and_slide()
	$Area2D/CharacterBody2D/Atk_CL.ObJ_Dict = Wenpeon_Dict
func Jummp():
	var jup = load("res://杂项脚本库/跳跃粒子.tscn")
	var jump = jup.instantiate()
	jump.position = position 
	jump.position.y += 5
	get_node("/root/Node2D").add_child(jump)
	pass
func Volume_re(): ##血条调整
	Volume -= randi_range(1,1)
	var Xue = $"画布/UI/血条/ColorRect"
	if Xue.size.x == 0:
		var tween = get_tree().create_tween()
		var pos = 30 * $"画布/UI/血条".value 
		$"画布/UI/血条".value = Volume / Volume_Max
		$"画布/UI/血条/血量显示".text = str(Volume) + "/" + str(Volume_Max)
		var pos1 = 30 * $"画布/UI/血条".value
		Xue.size.x = pos - pos1
		Xue.position.x = pos1
		tween.tween_property(Xue, "size:x", 0, 0.5)
		tween_st = tween
		return
	if Xue.size.x > 0:
		tween_stop(tween_st)
		var tween = get_tree().create_tween()
		var pos = 30 * $"画布/UI/血条".value +  Xue.size.x
		$"画布/UI/血条".value = Volume / Volume_Max
		$"画布/UI/血条/血量显示".text = str(Volume) + "/" + str(Volume_Max)
		var pos1 = 30 * $"画布/UI/血条".value
		Xue.size.x = pos - pos1
		Xue.position.x = pos1
		tween.tween_property(Xue, "size:x", 0, 0.5)
		tween_st = tween
func tween_stop(tween):
	tween.kill()
func Tween_Switch():
	if Wenpeon_Dict[Wenpeon_Held-1].Magazine[0]:
		var tween = get_tree().create_tween()
		tween.tween_property($"画布/UI/弹匣/前", "modulate:a", 1, 0.2)
		tween.tween_property($"画布/UI/弹匣/后", "modulate:a", 1, 0.2)
	if Wenpeon_Dict[Wenpeon_Held-1].Magazine[0] == false:
		var tween = get_tree().create_tween()
		tween.tween_property($"画布/UI/弹匣/前", "modulate:a", 0, 0.2)
		tween.tween_property($"画布/UI/弹匣/后", "modulate:a", 0, 0.2)
func Knapsack_Display():
	var interface = $"画布/UI/配件系统"
	if interface.modulate.a == 1 :  #开启背包
		if $"画布/UI/介绍".modulate.a >= 1:
			Introduction(0)
		var tween = get_tree().create_tween()
		tween.set_parallel()
		tween.set_trans(1)
		tween.tween_property(interface, "modulate:a", 0, 0.5)
		tween.tween_property(interface, "position", Vector2(0,0), 0.5)
		tween.tween_property(interface, "scale", Vector2(0,0), 0.5)
		return
	if interface.modulate.a <= 0 : #关闭背包
		var List = Knapsack.Knapsack_List 
		for i in List:
			var Liest = Knapsack.Knapsack_List[i]
			if Liest[2] != null:
				$"画布/UI/配件系统/ItemList".set_item_icon(i,Liest[0])
				$"画布/UI/配件系统/ItemList".set_item_text(i,Liest[1])
			if Liest[2] == null:
				$"画布/UI/配件系统/ItemList".set_item_icon(i,load("res://素材库/UI图标/爱のUI/透明.png"))
				$"画布/UI/配件系统/ItemList".set_item_text(i,"      ")
			pass
		var tween = get_tree().create_tween()
		tween.set_parallel()
		tween.set_trans(1)
		tween.tween_property(interface, "modulate:a", 1, 0.5)
		tween.tween_property(interface, "position", Vector2(-512,-317), 0.5)
		tween.tween_property(interface, "scale", Vector2(1,1), 0.5)
		return
func Tween_Down():
	var tween = get_tree().create_tween()
	tween.set_parallel()
	tween.set_trans(1)
	tween.tween_property($"画布/UI/介绍/RichTextLabel", "modulate:a", 0, 0.5)
	tween.tween_property($"画布/UI/介绍", "modulate:a", 0, 0.5)
	tween.tween_property($"画布/UI/介绍", "position", Vector2(0,0), 0.5)
	tween.tween_property($"画布/UI/介绍", "scale", Vector2(0,0), 0.5)
func Kna_click(ID,pos,Nopl): #点击背包显示简介
	var Obj = Knapsack.Knapsack_List[ID]
	if Obj[2]!= null:
		$"画布/UI/介绍/RichTextLabel".modulate.a = 1
		var introduce = Obj[2].Fittings
		$"画布/UI/介绍/RichTextLabel".text = introduce
		if $"画布/UI/介绍".modulate.a <= 0:
			Introduction(introduce)
	pass
func Introduction(text): ##简介tween模块
	if $"画布/UI/介绍".modulate.a <= 0 :
		var image = $"画布/UI/介绍"
		var tween = get_tree().create_tween()
		tween.set_parallel()
		tween.set_trans(1)
		tween.tween_property(image, "modulate:a", 1, 0.5)
		tween.tween_property(image, "position", Vector2(-942,-119), 0.5)
		tween.tween_property(image, "scale", Vector2(1,1), 0.5)
		return image.modulate.a
	if $"画布/UI/介绍".modulate.a >= 1 :
		var image = $"画布/UI/介绍"
		var tween = get_tree().create_tween()
		tween.set_parallel()
		tween.set_trans(1)
		tween.tween_property(image, "modulate:a", 0, 0.5)
		tween.tween_property(image, "position", Vector2(0,0), 0.5)
		tween.tween_property(image, "scale", Vector2(0,0), 0.5)
		return image.modulate.a
