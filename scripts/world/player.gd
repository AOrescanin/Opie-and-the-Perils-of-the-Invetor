class_name Player
extends CharacterBody2D

# **************************************************************************************************

const FLIPPED_SPRITE_OFFSET: float =  -4.0 # Offset to center sprite when flipped

var physics_delta_time: float = 0.0
var direction: int = 0
var previous_velocity:= Vector2.ZERO
var is_wall_grabbing: bool = false
var is_wall_climbing: bool = false
var is_gliding_unlocked: bool = false
var is_gliding: bool = false
var is_swiping: bool = false
var is_facing_right: bool = true
var is_dead: bool = false

@onready var animated_sprite = $AnimatedSprite2D
@onready var swipe_area = $SwipeArea
@onready var swipe_collision = $SwipeArea/SwipeCollision


func _ready():
	GameManager.player = self
	
# **************************************************************************************************

func _process(_delta):
	if is_dead or GameManager.is_paused:
		return
	
	# Do not get user input or flip sprite while the character is wall jumping or dashing
	if not GameManager.is_room_paused and not is_wall_jumping and not is_dashing:
		gather_input()
		flip_sprite()
		
	play_animations()

# **************************************************************************************************

func gather_input():
	direction = Input.get_axis("move_left", "move_right")	# Get input direction: -1, 0, 1
	
	is_wall_grabbing = Input.is_action_pressed("grab or glide") and (is_on_wall_only() or (is_on_wall() and is_on_ceiling()))
	
	is_wall_climbing = Input.is_action_pressed("up") and is_wall_grabbing
	
	is_gliding = (is_gliding_unlocked and Input.is_action_pressed("grab or glide") 
				 and not is_on_floor())
				
	if Input.is_action_just_pressed("swipe") and not is_swiping:
		is_swiping = true
		swipe_timer.start()
		#swipe_area.monitorable = true
		swipe_collision.disabled = false
	
				

# **************************************************************************************************

func flip_sprite():
	# Flip in proper direction according to user input
	if direction > 0:
		flip_right()
	elif direction < 0:
		flip_left()
		
# **************************************************************************************************
		
func flip_right():
	animated_sprite.flip_h = false
	animated_sprite.position.x = 0
	swipe_area.position.x = 0
	is_facing_right = true
	
# **************************************************************************************************
	
func flip_left():
	animated_sprite.flip_h = true
	animated_sprite.position.x = FLIPPED_SPRITE_OFFSET
	swipe_area.position.x = -18
	is_facing_right = false

# **************************************************************************************************

var sprite_starting_pos:= Vector2(0, -13.0)
var right_wall_sprite_offset:= Vector2(-3.0, -8.0)
var left_wall_sprite_offset:= Vector2(-1.0, -8.0)
var is_falling: bool
var start_falling_velocity: float = 15.0
@onready var swipe_timer = $SwipeTimer

func play_animations():
	# Play animations depending on state of character
	
	if GameManager.is_cutscene_playing:
		animated_sprite.play("idle")
		return
	
	if is_on_floor():
		is_falling = false
		
		if not is_facing_right:
			animated_sprite.position.x = FLIPPED_SPRITE_OFFSET
		
		if is_dashing:
			animated_sprite.play("dash")
		elif is_swiping:
			animated_sprite.play("swipe")
		elif direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		if is_dashing:
			animated_sprite.play("dash")
		#elif is_climb_hopping:
			#animated_sprite.play("ledge_climb")
		elif is_wall_grabbing and not is_wall_jumping and not is_climb_hopping:
			if is_facing_right:
				animated_sprite.position = right_wall_sprite_offset
			else:
				animated_sprite.position = left_wall_sprite_offset
			
			if is_wall_climbing:
				animated_sprite.play("wall_climb")
			else:
				animated_sprite.play("wall_grab")
		elif is_swiping:
			animated_sprite.play("swipe")
		elif velocity.y > start_falling_velocity and not is_falling:
			is_falling = true
			animated_sprite.play("fall")
			
		if not is_wall_grabbing:
			animated_sprite.position = sprite_starting_pos
		
	#if is_wall_grabbing and not is_wall_jumping:
		#if is_wall_climbing:
			#animated_sprite.play("wall_climb")
		#else:
			#animated_sprite.play("wall_grab")
	#elif is_dashing and not can_dash:
		#animated_sprite.play("dash")
	#elif is_on_floor():
		#is_falling = false
		#
		#if direction == 0:
			#animated_sprite.play("idle")
		#else:
			#animated_sprite.play("run")
	#elif velocity.y > start_falling_velocity and not is_falling:
		#animated_sprite.play("fall")
		#is_falling = true

# **************************************************************************************************

func _physics_process(delta):
	physics_delta_time = delta # Store delta for use in other functions
	
	check_collisions()
	
	handle_gravity()
	handle_jump()
	handle_wall_jump()
	handle_wall_climb()
	handle_dash()
	
	if not GameManager.is_cutscene_playing:
		apply_movement()
	
	previous_velocity = velocity # Store the velocity of the previous frame for lerping
	
# **************************************************************************************************

var is_wall_sliding: bool = false


func check_collisions():
	# Sets wall sliding only if there is horizontal input
	if is_on_wall() and not is_on_floor() and direction != 0:
		is_wall_sliding = true
	else:
		is_wall_sliding = false
		
# **************************************************************************************************

func _on_room_detector_area_entered(area):
	# Gets the collision shape and size of room
	var collision_shape: CollisionShape2D = area.get_node("CollisionShape2D")
	var size: Vector2 = collision_shape.shape.extents * 2
	#var size : Vector2 = collision_shape.shape.get_rect().size
	
	# Changes camera's current room and size. Check player_camera script for more info
	GameManager.change_room(collision_shape.global_position, size)
	
# **************************************************************************************************

const IN_AIR_Y_LERP_WEIGHT: float = 0.9
const IN_AIR_X_LERP_WEIGHT: float = .15
const WALL_SLIDE_SPEED: float = 30.0
const WALL_GRAB_SPEED: float = -30.0
const GLIDE_FALL_SPEED: float = 12.0
const MAX_FALL_SPEED: float = 180.0


func handle_gravity():
	# Add the gravity
	if not is_on_floor():
		velocity.y += get_gravity(velocity) * physics_delta_time
		velocity.y = lerp(previous_velocity.y, velocity.y, IN_AIR_Y_LERP_WEIGHT)
	
	# Clamp how fast the character can fall depending on current state
	if not is_wall_jumping and not is_dashing:
		if is_wall_grabbing:
			#velocity.y = clamp(velocity.y, get_platform_velocity().y, get_platform_velocity().y)
			#velocity.x = clamp(velocity.x, get_platform_velocity().x, get_platform_velocity().x)
			velocity.y = clamp(velocity.y, get_platform_velocity().y, get_platform_velocity().y)
			#print(get_platform_velocity())
		elif is_wall_sliding:
			velocity.y = clamp(velocity.y, JUMP_VELOCITY, WALL_SLIDE_SPEED)
		elif is_gliding:
			velocity.y = clamp(velocity.y, JUMP_VELOCITY, GLIDE_FALL_SPEED)
	else:
		velocity.y = clamp(velocity.y, JUMP_VELOCITY, MAX_FALL_SPEED)
	
# **************************************************************************************************

const AIR_HANG_VELOCITY: float = 45.0
const AIR_HANG_GRAVITY: float = 450.0
const FALL_GRAVITY: float = 1200.0

# Get the gravity from the project settings to be synced with RigidBody nodes
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")


func get_gravity(vel: Vector2):
	# Return different gravities depeneding on current velocity
	# Used for longer hang time and faster fall gravity
	if abs(vel.y) < AIR_HANG_VELOCITY:
		return AIR_HANG_GRAVITY
	elif vel.y < 0:
		return gravity
	else:
		return FALL_GRAVITY

# **************************************************************************************************

const COYOTE_TIME: int = 9 # How long player can jump after they leave ground
const JUMP_BUFFER_TIME: int = 9 # How long before player hits ground will jump still register
const JUMP_VELOCITY: float = -210.0
const VARIABLE_JUMP_RATIO: float = 3.0 # How much to divide velocity by if jump is realeased early

var coyote_counter: int = 0
var jump_buffer_counter: int = 0
var can_jump: bool = true
var is_wall_jumping: bool = false


func handle_jump():
	# Resets coyote counter when player is on floor and increment down when not
	if is_on_floor():
		coyote_counter = COYOTE_TIME
	else:
		if coyote_counter > 0:
			coyote_counter -= 1
	
	# Handles jump buffer
	if jump_buffer_counter > 0:
		jump_buffer_counter -= 1
			
	if Input.is_action_just_pressed("jump"):
		jump_buffer_counter = JUMP_BUFFER_TIME

	
	if jump_buffer_counter > 0 and coyote_counter > 0:
		execute_jump()
		
	# Handles variable jump height
	if Input.is_action_just_released("jump") and not is_wall_jumping:
		if velocity.y < 0:
			velocity.y = velocity.y / VARIABLE_JUMP_RATIO
			
# **************************************************************************************************

func execute_jump():
	animated_sprite.play("jump")
	velocity.y = JUMP_VELOCITY
	jump_buffer_counter = 0
	coyote_counter = 0

# **************************************************************************************************

const WALL_COYOTE_TIME: float = 9 # How long player can wall jump after stopping a wall slide
const WALL_JUMP_DELAY: int = 12 # How long the wall jump state lasts
const WALL_JUMP_VELOCITY:= Vector2(96.0, -210.0) # WAS 96 and -210

var wall_coyote_counter: float = 0
var wall_jump_delay_counter: float = 0
var can_wall_jump: bool = false

@onready var ray_cast_front = $RayCastFront
@onready var ray_cast_back = $RayCastBack


func handle_wall_jump():
	# Resets coyote counter when player is wall sliding and increment down when not
	#if is_wall_sliding or is_on_wall_only():
		#wall_coyote_counter = WALL_COYOTE_TIME
		#is_wall_jumping = false
	#else:
		#if wall_coyote_counter > 0:
			#wall_coyote_counter -= 1
	
	# Handles wall jump delay
	if is_wall_jumping:
		wall_jump_delay_counter -= 1
		
	if wall_jump_delay_counter == 0:
		is_wall_jumping = false

	#if Input.is_action_just_pressed("jump") and wall_coyote_counter > 0:
		#execute_wall_jump()
	
	if Input.is_action_just_pressed("jump") and (ray_cast_front.is_colliding() or ray_cast_back.is_colliding() or is_wall_grabbing) and not is_on_floor():
		execute_wall_jump()
	
# **************************************************************************************************
	
func execute_wall_jump():
	animated_sprite.play("jump")
	is_wall_jumping = true
	wall_jump_delay_counter = WALL_JUMP_DELAY
	
	# Sets character velocity for wall jump depending on which direction they are facing
	if ray_cast_ledge_front.is_colliding():
		velocity.x = -WALL_JUMP_VELOCITY.x
		velocity.y = WALL_JUMP_VELOCITY.y
		
		if is_facing_right:
			flip_left()
			
	elif ray_cast_ledge_back.is_colliding():
		velocity = WALL_JUMP_VELOCITY
		
		if not is_facing_right:
			flip_right()
	
	#wall_coyote_counter = 0

# **************************************************************************************************

const WALL_CLIMB_SPEED: float = -30.0
const CLIMB_HOP_VELOCITY:= Vector2(40, -60)
const MOVING_PLATFORM_CLIMB_HOP_MODIFIER = 21

var is_climb_hopping: bool = false;

@onready var ray_cast_ledge_front = $RayCastLedgeFront
@onready var ray_cast_ledge_back = $RayCastLedgeBack


func handle_wall_climb():
	if not is_wall_jumping:
		# Handles wall climb up and down
		if is_wall_climbing:
			velocity.y = WALL_CLIMB_SPEED
		elif is_wall_grabbing and Input.is_action_pressed("down"):
			velocity.y = -WALL_CLIMB_SPEED
		
	# Handles cimbing over a ledge(Climb hopping)
	if (
	is_wall_climbing and ((ray_cast_front.is_colliding() and not ray_cast_ledge_front.is_colliding()) 
	or (ray_cast_back.is_colliding() and not ray_cast_ledge_back.is_colliding()))
	):
		is_climb_hopping = true
		animated_sprite.play("ledge_climb")
		velocity.y = CLIMB_HOP_VELOCITY.y
		$ClimbHopTimer.start()
	
	if is_climb_hopping:
		if get_platform_velocity() != Vector2(0,0):
			velocity.x = get_platform_velocity().x * MOVING_PLATFORM_CLIMB_HOP_MODIFIER
		elif is_facing_right:
			velocity.x = CLIMB_HOP_VELOCITY.x
		else:
			velocity.x = -CLIMB_HOP_VELOCITY.x
			
# **************************************************************************************************
			
func _on_climb_hop_timer_timeout():
	is_climb_hopping = false
			
# **************************************************************************************************

const DASH_SPEED: float = 270.0
const DASH_Y_BOOST: float = -60.0
const DASH_BUFFER_TIME: int = 9	# How long before player hits ground will dash still register

var dash_buffer_counter: int = 0
var can_dash: bool = true
var is_dashing: bool = false


func handle_dash():
	# Handles dash buffer
	if dash_buffer_counter > 0:
		dash_buffer_counter -= 1
	
	if can_dash and Input.is_action_just_pressed("dash"):
		dash_buffer_counter = DASH_BUFFER_TIME
		
	if can_dash and dash_buffer_counter > 0 and coyote_counter > 0:
		can_dash = false
		is_dashing = true
		$DashLengthTimer.start()
		$DashCooldownTimer.start()
		dash_buffer_counter = 0
		coyote_counter = 0
		
	# Apply dash movement
	if is_dashing:
		if is_facing_right:
			velocity = Vector2(DASH_SPEED, DASH_Y_BOOST)
		else:
			velocity = Vector2(-DASH_SPEED, DASH_Y_BOOST)
			
# **************************************************************************************************

func _on_dash_length_timer_timeout():
	is_dashing = false
	
# **************************************************************************************************

func _on_dash_cooldown_timer_timeout():
	can_dash = true

# **************************************************************************************************

const NORMAL_ACCELERATION: float = 15.0
const NORMAL_SPEED: float = 90.0
const GLIDING_X_LERP_WEIGHT: float = 0.03
const GROUNDED_X_LERP_WEIGHT: float = 0.3


func apply_movement():
	# Apply movement
	if not is_dashing and not is_wall_jumping:	
		if direction:
			if not is_gliding:
				velocity.x += direction * NORMAL_ACCELERATION
			else:
				velocity.x = lerp(velocity.x, direction * NORMAL_SPEED, GLIDING_X_LERP_WEIGHT)
		elif is_on_floor():
			velocity.x = lerp(velocity.x, 0.0, GROUNDED_X_LERP_WEIGHT)
		else:
			velocity.x = lerp(velocity.x, 0.0, IN_AIR_X_LERP_WEIGHT)
			
	if Input.is_action_pressed("grab or glide") and (ray_cast_front.is_colliding() or ray_cast_back.is_colliding()) and not is_on_floor():
		if get_platform_velocity().x != 0:
			print("MOVING PLATFORM")
		
	# Clamp speed depending on state of player
	if not is_wall_jumping and not is_dashing and not is_wall_grabbing:
		velocity.x = clamp(velocity.x, -NORMAL_SPEED, NORMAL_SPEED)
	elif is_wall_jumping:
		velocity.x = clamp(velocity.x, -WALL_JUMP_VELOCITY.x, WALL_JUMP_VELOCITY.x)
	elif is_dashing:
		velocity.x = clamp(velocity.x, -DASH_SPEED, DASH_SPEED)
	elif is_wall_grabbing and get_platform_velocity().x != 0:
		#velocity.x = clamp(velocity.x, get_platform_velocity().x, get_platform_velocity().x)
		#velocity.x += get_platform_velocity().x
		#print('1')
		position.x = get_last_slide_collision().get_position().x
		
	#var input_direction = Input.get_vector("move_left", "move_right", "up", "down")
	#input_direction = input_direction.normalized()
	#velocity.x = input_direction.x * SPEED;
	move_and_slide()

# **************************************************************************************************

func spring(power: float, direction: float) -> void:
	velocity.x = velocity.x - cos(direction) * power
	velocity.y = -sin(direction) * power

func die():
	animated_sprite.play("die")


func _on_swipe_timer_timeout():
	is_swiping = false
	#swipe_area.monitorable = false
	swipe_collision.disabled = true


func _on_area_2d_body_entered(body):
	if body.is_in_group("Crate"):
		print(body.collision_layer)
		print(body.collision_mask)
		body.collision_layer = 1
		body.collision_mask = 1
		print("HERE!")
		print(body.collision_layer)
		print(body.collision_mask)


func _on_area_2d_body_exited(body):
	if body.is_in_group("Crate"):
		body.collision_layer = 64
		body.collision_mask = 64
		print("HERE2")
		print(body.collision_layer)
		print(body.collision_mask)

