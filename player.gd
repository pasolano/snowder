extends CharacterBody2D

signal hit

@export var speed = 300.0
@export var jump_speed = -750.0
@export var gravity = 2000.0
var screen_size # Size of the game window.
var controllable = true # Whether player has control of the character or not.
						# Useful for taking away control to let animation play out or for cutscenes.



# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	Dialogic.signal_event.connect(_on_cutscene) #makes Player listen for Dialogic signals

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if controllable == false:
		return
	if Input.is_action_just_pressed("change_perspective"):
		if motion_mode == MOTION_MODE_FLOATING:
			motion_mode = MOTION_MODE_GROUNDED
		else:
			motion_mode = MOTION_MODE_FLOATING
		
		# Player should be still after changing perspective
		velocity = Vector2.ZERO
		
	else:
		if motion_mode == MOTION_MODE_GROUNDED:
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
	if controllable == false:
		return
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

#placeholder for death by falling/spikes
func _on_fall_gap_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	controllable = false
	velocity.y = 0
	velocity.x = 0
	_animated_sprite.play('dead')

func _on_animated_sprite_2d_animation_finished():
	get_tree().reload_current_scene()

#arrest control during dialogue (game crashes if player dies while dialogue is running)
#although could also be fixed by reseting player position rather than reloading scene?
#which might be better cuz I want to track player deaths as a variable maybe
func _on_cutscene(argument:String):
	if argument == "no_control":
		velocity.y = 0
		velocity.x = 0
		controllable = false
	if argument == "yes_control":
		controllable = true

