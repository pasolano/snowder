extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_animated_sprite_2d_animation_finished():
	PlayerVars.died_in_s4 += 1 # tracks player deaths on this scene to trigger cutscene
	
