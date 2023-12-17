extends Area2D

signal end_reached

@export var player: CharacterBody2D

func _ready():
	assert(player)

func _on_body_entered(body):
	if body == player:
		emit_signal("end_reached")
		print('hit')
