extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const ROLL_SPEED = 500.0
const ROLL_DURATION = 0.5 # Roll duration in seconds
const ATTACK_DURATION = 0.2 # Attack duration in seconds
const DASH_SPEED = 500.0
const DASH_DURATION = 0.2 # Dash attack duration in seconds

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Get the animatedsprite2d child node to control animation
# use animatedsprite2d method like play() and stop() to control animation
var playerAnim
var facing_right = false
var in_action = false

# Variables for rolling state
var is_rolling = false
var roll_timer = 0.0

# Variables for attacking state
var is_attacking = false
var attack_timer = 0.0

# Variables for dash attacking state
var is_dashing = false
var dash_timer = 0.0

################################
# Stat
var HP = 100
var Atk = 10


func _ready():
	$Area2D.visible = false
	playerAnim = $PlayerAnim
	playerAnim.play("default")

func _physics_process(delta):
	
	var direction = Input.get_axis("ui_left","ui_right")
		
	if not in_action:
		if(Input.is_anything_pressed()==false):
			playerAnim.play("default")
		
		# Add the gravity.
		if not is_on_floor():
			velocity.y += gravity * delta

		# Handle Jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			
		# Handle Roll.
		if Input.is_action_just_pressed("roll") and is_on_floor():
			in_action = true
			is_rolling = true
			roll_timer = ROLL_DURATION
			playerAnim.play("roll")
			
		# Handle Attack
		if Input.is_action_just_pressed("attack"):
			in_action = true
			is_attacking = true
			$Area2D.visible = true
			attack_timer = ATTACK_DURATION
			playerAnim.play("attack")
			
		# Handle Dash Attack
		if Input.is_action_just_pressed("dash_attack"):
			in_action = true
			is_dashing = true
			$Area2D.visible = true
			dash_timer = DASH_DURATION
			playerAnim.play("attack2")
	
	# Rolling logic
	if is_rolling:
		roll_timer -= delta
		if roll_timer <= 0:
			is_rolling = false
			in_action = false
			playerAnim.play("default")
		if facing_right:
			velocity.x = 1 * ROLL_SPEED
		else:
			velocity.x = -1 * ROLL_SPEED
	
	elif is_attacking:
		attack_timer -= delta;
		if attack_timer <= 0:
			is_attacking = false
			in_action = false
			$Area2D.visible = false
			playerAnim.play("default")
		
		if not is_on_floor():
			velocity.y += gravity * delta
	
	elif is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false
			in_action = false
			playerAnim.play("default")
			
		if facing_right:
			velocity.x = 1 * DASH_SPEED
		else:
			velocity.x = -1 * DASH_SPEED	
			
		if not is_on_floor():
			velocity.y += gravity * delta	
	
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

func doDamage(dmg):
	print("before", HP)
	HP-=dmg
	print(HP)


func _on_area_2d_body_entered(body):
	print(body.get_name())
	if body.get_name().contains("GolemBoss"):
		body.take_damage()
