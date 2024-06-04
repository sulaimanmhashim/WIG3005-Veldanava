extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const ROLL_SPEED = 500.0
const ROLL_DURATION = 0.5 # Roll duration in seconds

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Get the animatedsprite2d child node to control animation
# use animatedsprite2d method like play() and stop() to control animation
var playerAnim

# Variables for rolling state
var is_rolling = false
var facing_right = false
var roll_timer = 0.0

func _ready():
	playerAnim = $PlayerAnim
	playerAnim.play("default")

func _physics_process(delta):
	
	var direction = Input.get_axis("ui_left","ui_right")
		
	if not is_rolling:
		if(Input.is_anything_pressed()==false):
			playerAnim.play("default")
		
		# Add the gravity.
		if not is_on_floor():
			velocity.y += gravity * delta

		# Handle Jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			
		if Input.is_action_just_pressed("roll") and is_on_floor():
			is_rolling = true
			roll_timer = ROLL_DURATION
			playerAnim.play("roll")
	
	# Rolling logic
	if is_rolling:
		roll_timer -= delta
		if roll_timer <= 0:
			is_rolling = false
			playerAnim.play("default")
			

		if facing_right == true:
			velocity.x = 1 * ROLL_SPEED
		else:
			velocity.x = -1 * ROLL_SPEED
		
	
	else:
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		
		if direction:
			if is_on_floor():
				playerAnim.play("run")
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		
		if direction>0:
			playerAnim.flip_h=false
			facing_right = true
		elif direction<0:
			playerAnim.flip_h=true
			facing_right = false
		
		if velocity.y>0:
			playerAnim.play("fall")
		elif velocity.y<0:
			playerAnim.play("jump")

	move_and_slide()
