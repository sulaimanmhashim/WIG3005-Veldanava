extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var health = 100
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var slimeAnim

func _ready():
	slimeAnim = $SlimeAnim

func _physics_process(delta):
	if is_on_floor():
		slimeAnim.play("idle")

	if not is_on_floor():
		velocity.y += gravity * delta
	
	if velocity.y > 0:
		slimeAnim.play("fall")
	elif velocity.y < 0:
		slimeAnim.play("jump")
	
	move_and_slide()

func take_damage(damage):
	health -= damage
	if health <= 0:
		kill()

func kill():
	# Play death animation or remove from scene
	slimeAnim.play("defeated")
	queue_free()


func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		var player = body
		# Call function on the player script to handle attack
		player.attack_slime(self)

