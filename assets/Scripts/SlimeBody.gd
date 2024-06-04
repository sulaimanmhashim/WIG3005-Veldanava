extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var slimeAnim

func _ready():
	slimeAnim = $SlimeAnim

func _physics_process(delta):
	if is_on_floor():
		slimeAnim.play("idle")
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	#if direction>0:
	#	slimeAnim.flip_h=false
	#elif direction<0:
	#	slimeAnim.flip_h=true
	
	if velocity.y>0:
		slimeAnim.play("fall")
	elif velocity.y<0:
		slimeAnim.play("jump")
	
	move_and_slide()
