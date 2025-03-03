extends CharacterBody2D
var Text
var Speed
var San
func _ready() -> void:
	$Sprite2D.texture = Text
	$Timer.timeout.connect(queue_free)
	velocity = transform.x  * (Speed + San)
func  _physics_process(delta: float) -> void:
	move_and_slide()
func kill(time):
	$Timer.start(time)
