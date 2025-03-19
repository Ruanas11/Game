extends CharacterBody2D
var Damage_int  = 0
const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
func _ready(): 
	#伤害显示
	#调色部分
	#===============================
	Damage_int = float(Damage_int) * -1
	var Int = Damage_int
	if Int <= -50.1:
		Int = -50
	scale = Vector2(Int*-1/5+2,Int*-1/5+2)
	if Damage_int <= 0:
		$Label.label_settings.font_color = Color(0,1,0,1)
	if Damage_int <= 0:
		$Label.label_settings.font_color = Color(3,0,0,1)
	#===============================
	#伤害数字获取
	#==========================================
	$Label.text = str(Damage_int)
	#========================================
	#重力设置
	#===========================================
	velocity.x = randf_range(-0.5,0.5) * SPEED
	velocity.y =  randf_range(-0.5,-0.5) * SPEED
	#==========================================
	#消失动画
	#=====================================
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(1)
	tween.tween_property(self,"modulate:a",0,0.8)
	var tween1 = get_tree().create_tween()
	tween1.set_ease(Tween.EASE_OUT)
	tween1.set_trans(1)
	tween1.tween_property(self,"scale",Vector2(0.2,0.2),2)
	#======================================
	pass
func _physics_process(delta):
	#自杀
	
	#=================================
	if self.modulate.a == 0 :
		self.queue_free()
	#=============================
	#执行向量
	#=================================
	velocity.y += gravity * delta
	move_and_slide()
	#===============================
	
