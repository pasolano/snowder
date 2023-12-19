extends CharacterBody2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var GRAVITY : float = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var follow : PathFollow2D = get_parent()
@onready var bro := $AnimatedSprite2D
const SPEED := 120.0
const END_RAT := 0.99 # tbh this is just a stupid stopgap because the pathing function wasn't working

func _physics_process(delta):
	if follow.get_progress_ratio() < END_RAT:
		follow.set_progress(follow.get_progress() + SPEED * delta)
		bro.play("side")
	else:
		follow.set_progress_ratio(END_RAT)
		bro.play("idle_side")
	

func _on_area_2d_body_shape_entered(_body_rid, _body, _body_shape_index, _local_shape_index):
	#check if dialogue is already happening
	if not Dialogic.current_timeline:
		#initiate dialogue
		Dialogic.start("first_tl")
		var layout := Dialogic.start("first_tl")
		layout.register_character(load("res://bro.dch"), $".")
