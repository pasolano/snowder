extends Marker2D

# relative position to walk to
# @export var walk_to := Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	var player := get_tree().get_first_node_in_group("Player")
	player.position = position

#func _physics_process(delta):
	#if spawnee.position != self.position + walk_to: # how to check if they go beyond
		#pass
