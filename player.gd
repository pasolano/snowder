extends CharacterBody2D

signal hit

@export var speed = 300.0
@export var jump_speed = -400.0
@export var gravity = 600.0
var screen_size # Size of the game window.

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Input.is_action_just_pressed("change_perspective"):
		if motion_mode == MOTION_MODE_FLOATING:
			motion_mode = MOTION_MODE_GROUNDED
		else:
			motion_mode = MOTION_MODE_FLOATING
	#
	#if motion_mode == MOTION_MODE_FLOATING:
		#velocity = Vector2.ZERO
	#else:
	#	velocity.x = 0
	#
	var direction = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_down"):
		if motion_mode == MOTION_MODE_FLOATING:
			direction.y += 1
	if Input.is_action_pressed("move_up"):
		if motion_mode == MOTION_MODE_FLOATING:
			direction.y -= 1
		elif is_on_floor():
			velocity.y = jump_speed
#
	if direction.length() > 0:
		velocity += direction.normalized() * speed * delta
		#print(velocity.normalized(), speed, delta)
		##$AnimatedSprite2D.play()
	#else:
		#pass
		##$AnimatedSprite2D.stop()
	#

	if motion_mode == MOTION_MODE_GROUNDED:
		velocity.y += gravity * delta

	
	## No vertical velocity when touching the ground
	## TODO unhardcode floor once physics work
#
	## Player should be still after changing perspective
	if Input.is_action_just_pressed("change_perspective"):
		velocity = Vector2.ZERO
#
	#print(velocity)
#
	##position += velocity * delta
	##position = position.clamp(Vector2.ZERO, screen_size)
	
	move_and_slide()
	
	#####
	
	# Add the gravity.
	#velocity.y += gravity * delta

	# Handle Jump.
	#if Input.is_action_just_pressed("move_up") and is_on_floor():
		#velocity.y = jump_speed

	# Get the input direction.
	#var direction = Input.get_axis("ui_left", "ui_right")
	#velocity.x = direction * speed

	#move_and_slide()

func _on_body_entered(body):
	hide() # Player disappears after being hit.
	hit.emit()
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
