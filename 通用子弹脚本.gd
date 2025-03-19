extends CharacterBody2D
var Text
var Speed
var San
var Damage = 0
var Penet
func _ready() -> void:
	$Sprite2D.texture = Text
	$Timer.timeout.connect(queue_free)
	velocity = transform.x  * (Speed)
	$Area2D.Penet = Penet #穿透次数赋予
	$Area2D.Obj = self
func  _physics_process(delta: float) -> void:
	
	var aDamage = "%.1f" % Damage
	$Area2D.Damage = aDamage
	move_and_slide()
func kill(time):
	$Timer.start(time)
