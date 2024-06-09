extends Area2D
 
 
@onready var animated_sprite = $AnimatedSprite2D
@onready var player = get_parent().find_child("PlayerBody")
 
var acceleration: Vector2 = Vector2.ZERO 
var velocity: Vector2 = Vector2.ZERO
 
func _physics_process(delta):
 
	acceleration = (player.global_position - global_position).normalized() * 700
 
	velocity += acceleration * delta
	rotation = velocity.angle()
 
	velocity = velocity.limit_length(150)
 
	position += velocity * delta
 
 
func _on_body_entered(_body):
	queue_free()
