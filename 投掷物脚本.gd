extends CharacterBody2D
var Speed :float
var gravity :float
var rot_speed = 0
var Text
var San
var Ve
var Damage
var Penet
func _ready() -> void:
	$Sprite2D/Sprite2D.texture = Text
	$Timer.timeout.connect(queue_free)
	$Area2D.Penet = Penet #穿透次数赋予
	$Area2D.Obj = self
	var Float =rotation_degrees - int(rotation_degrees)
	Ve =  (Vector2(cos(rotation),sin(rotation)))
	velocity = Ve
func _physics_process(delta: float) -> void:
	var aDamage = "%.1f" % Damage
	$Area2D.Damage = aDamage
	rotation_degrees = lerp(float(rotation_degrees),float(90),delta*gravity/10)
	Ve = Ve.move_toward(Vector2(0,1),gravity * delta/10)
	velocity = Ve * Speed * delta * 50
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite2D/Sprite2D, "rotation_degrees", $Sprite2D/Sprite2D.rotation_degrees + rot_speed, 0.2)
	move_and_slide()
func kill(time):
	$Timer.start(time)
