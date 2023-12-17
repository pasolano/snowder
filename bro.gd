extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var _follow :PathFollow2D = get_parent()
@onready var _bro = $AnimatedSprite2D
var _speed :float = 120.0

func _physics_process(delta):
	if _follow.get_progress_ratio() != 1:
		_follow.set_progress(_follow.get_progress() + _speed * delta)
		_bro.play('side')
	else:
		_follow.set_progress_ratio(1)
	print(_follow.get_progress())
