extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const ROLL_SPEED = 500.0
const ROLL_DURATION = 0.5 # Roll duration in seconds
const ATTACK_DURATION = 0.2 # Attack duration in seconds
const DASH_SPEED = 500.0
const DASH_DURATION = 0.2 # Dash attack duration in seconds

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var playerAnim
var facing_right = false
var in_action = false

var is_rolling = false
var roll_timer = 0.0

var is_attacking = false
var attack_timer = 0.0

var is_dashing = false
var dash_timer = 0.0

func _ready():
	playerAnim = $PlayerAnim
	playerAnim.play("default")

func _physics_process(delta):
	var direction = Input.get_axis("ui_left","ui_right")
	
	if not in_action:
		if not Input.is_anything_pressed():
			playerAnim.play("default")
		
		if not is_on_floor():
			velocity.y += gravity * delta

		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			
		if Input.is_action_just_pressed("roll") and is_on_floor():
			in_action = true
			is_rolling = true
			roll_timer = ROLL_DURATION
			playerAnim.play("roll")
			
		if Input.is_action_just_pressed("attack"):
			in_action = true
			is_attacking = true
			attack_timer = ATTACK_DURATION
			playerAnim.play("attack")
			
		if Input.is_action_just_pressed("dash_attack"):
			in_action = true
			is_dashing = true
			dash_timer = DASH_DURATION
			playerAnim.play("attack2")
	
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
		attack_timer -= delta
		if attack_timer <= 0:
			is_attacking = false
			in_action = false
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
		if direction:
			if is_on_floor():
				playerAnim.play("run")
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		
		if direction > 0:
			playerAnim.flip_h = false
			facing_right = true
		elif direction < 0:
			playerAnim.flip_h = true
			facing_right = false
		
		if velocity.y > 0:
			playerAnim.play("fall")
		elif velocity.y < 0:
			playerAnim.play("jump")

	move_and_slide()

func attack_slime(slime):
	if is_attacking or is_dashing:
		slime.take_damage(50)  # Assuming each attack reduces 50 health points.
		if slime.health <= 0:
			slime.kill()
