extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.get_axis("ui_left", "ui_right"):
		play("run")
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	#	play("jump")
	else:
		play("default")
	pass
