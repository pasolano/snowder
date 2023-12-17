extends Area2D

signal end_reached

@export var player: CharacterBody2D

func _ready():
	assert(player)

func _on_body_entered(body):
	if body == player:
		end_reached.emit()
		print('hit')
