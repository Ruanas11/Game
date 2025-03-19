extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play("跳跃")
	animation_finished.connect(queue_free)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
