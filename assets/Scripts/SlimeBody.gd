extends CharacterBody2D

var player_chase = false
var player = null

const SPEED = 0.4
const JUMP_VELOCITY = -400.0

var direction

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var slimeAnim

var HP = 50

func _ready():
	slimeAnim = $SlimeAnim

func _physics_process(delta):
	if player_chase:
		direction = player.global_position.x - global_position.x
		if direction:
			if is_on_floor():
				slimeAnim.play("move")
				velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		if direction>0:
			slimeAnim.flip_h=false
		elif direction<0:
			slimeAnim.flip_h=true
	
	if is_on_floor():
		slimeAnim.play("idle")
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if velocity.y>0:
		slimeAnim.play("fall")
	elif velocity.y<0:
		slimeAnim.play("jump")
	
	move_and_slide()


func _on_area_2d_body_entered(body):
	#print(body.get_name())
	if body.get_name().contains("Player"):
		player = body
		player_chase = true


func _on_area_2d_body_exited(body):
	if body.get_name().contains("Player"):
		player = null
		player_chase = false


func _on_attack_box_body_entered(body):
	if body.get_name().contains("Player"):
		print(body)
		body.doDamage(20)

func doDamage(dmg):
	HP-=dmg
	print(HP)
