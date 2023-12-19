extends Node2D

func _on_animated_sprite_2d_animation_finished():
	PlayerVars.died_in_s4 += 1 # tracks player deaths on this scene to trigger cutscene
