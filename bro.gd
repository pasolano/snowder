extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var _follow :PathFollow2D = get_parent()
@onready var _bro = $AnimatedSprite2D
var _speed :float = 120.0
var _end_rat = 0.99 #tbh this is just a stupid stopgap because the pathing function wasn't working


func _physics_process(delta):
	if PlayerVars.been_in_s4 == true: # tracks whether the cutscene has already happened
		return
	if PlayerVars.died_in_s4 < 2: # tracks whether the player has already tried jumping the gap before triggering cutscene
		return
	elif _follow.get_progress_ratio() < _end_rat:
		_follow.set_progress(_follow.get_progress() + _speed * delta)
		_bro.play('side')
	else:
		_follow.set_progress_ratio(_end_rat)
		_bro.play('idle_side')
	move_and_slide()
	

func _on_area_2d_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	#check if dialogue is already happening
	if Dialogic.current_timeline != null:
		return
	#initiate dialogue
	else:
		Dialogic.start('first_tl')
		var layout = Dialogic.start("first_tl")
		layout.register_character(load("res://bro.dch"), $".")
		PlayerVars.been_in_s4 = true


