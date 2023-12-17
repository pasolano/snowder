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
		
		# Player should be still after changing perspective
		velocity = Vector2.ZERO
		
	else:
		if motion_mode == MOTION_MODE_GROUNDED:
			var direction = Vector2.ZERO
			if Input.is_action_pressed("move_right"):
				velocity.x = speed
			if Input.is_action_pressed("move_left"):
				velocity.x = -speed
			if not Input.is_action_pressed("move_right") and not Input.is_action_pressed("move_left"):
				velocity.x = 0
			if Input.is_action_pressed("move_up") and is_on_floor():
				velocity.y = jump_speed
			
			velocity.y += gravity * delta
		
		# TODO make this grid-based?
		elif motion_mode == MOTION_MODE_FLOATING:
			var direction = Vector2.ZERO
			if Input.is_action_pressed("move_right"):
				direction.x += 1
			if Input.is_action_pressed("move_left"):
				direction.x -= 1
			if Input.is_action_pressed("move_down"):
				direction.y += 1
			if Input.is_action_pressed("move_up"):
				direction.y -= 1
				
			if direction.length() > 0:
				velocity = direction.normalized() * speed
			else:
				velocity = Vector2.ZERO
				
		move_and_slide()

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

@onready var _animated_sprite = $AnimatedSprite2D

func _process(_delta):
	if Input.is_action_pressed("move_right"):
		if motion_mode == MOTION_MODE_FLOATING:
			_animated_sprite.play('floating_side')
			_animated_sprite.flip_h = false
		elif is_on_floor():
			_animated_sprite.play('run')
			_animated_sprite.flip_h = false
	if Input.is_action_pressed("move_left"):
		if motion_mode == MOTION_MODE_FLOATING:
			_animated_sprite.play('floating_side')
			_animated_sprite.flip_h = true
		elif is_on_floor():
			_animated_sprite.play('run')
			_animated_sprite.flip_h = true
	if Input.is_action_pressed("move_down"):
		if motion_mode == MOTION_MODE_FLOATING:
			_animated_sprite.play('floating_down')
	if Input.is_action_pressed("move_up"):
		if motion_mode == MOTION_MODE_FLOATING:
			_animated_sprite.play('floating_up')
		else:
			_animated_sprite.play('jump')
			_animated_sprite.flip_h = false
			if velocity.x < 0:
				_animated_sprite.flip_h = true
	if velocity == Vector2.ZERO and motion_mode == MOTION_MODE_GROUNDED:
		_animated_sprite.play('idle')
