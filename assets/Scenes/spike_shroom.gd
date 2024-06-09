class_name  SpikeShroom
extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var wall_ray_cast_left = $Wall_Checks/Wall_RayCast_Left as RayCast2D
@onready var wall_ray_cast_right = $Wall_Checks/Wall_RayCast_Right as RayCast2D
@onready var floor_ray_cast_left = $Floor_Checks/Floor_RayCast_Left as RayCast2D
@onready var floor_ray_cast_right = $Floor_Checks/Floor_RayCast_Right as RayCast2D
@onready var player_tracker_raycast = $Player_Tracker_Pivot/Player_Tracker_Raycast as RayCast2D
@onready var player_tracker_pivot = $Player_Tracker_Pivot as Node2D
@onready var sprite_2d = $Sprite2D as Sprite2D
@onready var chase_timer = $Chase_Timer as Timer

@export var wander_speed : float = 40.0
@export var chase_speed : float = 80.0

var current_speed : float = 0.0
var player_found : bool = false
var player : PlayerEntity = null

enum States{
	Wander,
	Chase
}

var current_state = States.Wander

func _ready():
	player = get_tree().get_first_node_in_group("player")
	chase_timer.timeout.connect(on_timer_timeout)
	

func _physics_process(delta):
	
	handle_vision()
	track_player()
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func track_player():
	if player == null:
		return
	
	var direction_to_player : Vector2 = Vector2(player.position.x, player.position.y - 8)\
	 - player_tracker_raycast.position
	
	player_tracker_pivot.look_at(direction_to_player)
		

func handle_vision():
	if player_tracker_raycast.is_colliding():
		var collision_result = player_tracker_raycast.get_collider()
		
		if collision_result != player:
			return
		else:
			current_state = States.Chase
			chase_timer.start(1)
			player_found = true	
	else:
		player_found = false		


func on_timer_timeout() -> void:
	if player_found == false:
		current_state = States.Wander
	
