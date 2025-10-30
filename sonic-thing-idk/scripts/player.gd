extends CharacterBody2D

# Constants
const fps = 60
const JUMP_VELOCITY = -6.5 * fps
const acceleration_speed = 0.046875 * fps * fps # acceleration/frame squared
const deceleration_speed = 0.5 * fps * fps # deceleration/frame squared
const friction_speed = 0.046875 * fps * fps # friction/frame squared
const top_speed = 6 * fps
const upvelcap = -240

# Variables
var jumped = 0
var SPEED = 0
var debug_mode: bool = false

# References to other nodes
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var player: CharacterBody2D = $"."
@onready var jump: AudioStreamPlayer = $Jump
@onready var Xvel: Label = $XVel


func _input(event):
	if Input.is_action_just_pressed("Debug"):
		debug_mode = !debug_mode

func _physics_process(delta: float) -> void:
	
	# Get direction
	var direction := Input.get_axis("Left", "Right")
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jumped = 1
		jump.play()
	
	# Variable jump height
	if velocity.y < upvelcap and not Input.is_action_pressed("Jump"):
		velocity.y = upvelcap
	
	# movement stuff
	if is_on_floor():
		if direction != 0:
			# decelerate if moving opposite
			if sign(velocity.x) != direction and velocity.x != 0:
				velocity.x += direction * deceleration_speed * delta
			else:
				# Normal acceleration
				velocity.x += direction * acceleration_speed * delta
		else:
			# apply friction
			velocity.x = move_toward(velocity.x, 0, friction_speed * delta)
	else:
		# in air, keep momentum but slower accel
		if direction != 0:
			# slower accel in air
			velocity.x += direction * acceleration_speed * delta * 0.5
	
	# top speed cap
	velocity.x = clamp(velocity.x, -top_speed, top_speed)
	
	# Handle Debug mode.
	if debug_mode == false:
		Xvel.visible = false
	else:
		Xvel.visible = true
	
	SPEED = velocity.x
	
	Xvel.text = "Speed:" + str(abs(SPEED/fps))
	
	# Handle animations.
	
	# flip sprites
	if is_on_floor():
		if direction == 1 or sign(velocity.x) == 1:
			animated_sprite.flip_h = false
		elif direction == -1 or sign(velocity.x) == -1:
			animated_sprite.flip_h = true
	
	# Idle, Walk, and Jump
	if is_on_floor():
		if direction == 0 and velocity.x == 0:
			animated_sprite.play("Idle")
		else:
			animated_sprite.play("Walk")
	elif jumped == 1:
		animated_sprite.play("Jump")
		jumped = 0

	move_and_slide()
	
func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_text_backspace"):
		animated_sprite.rotate(0.05)
