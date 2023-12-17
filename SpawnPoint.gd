extends Marker2D

@export var spawnee: CollisionObject2D

# relative position to walk to
@export var walk_to: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(spawnee)
	spawnee.position = position

#func _physics_process(delta):
	#if spawnee.position != self.position + walk_to: # how to check if they go beyond
		#pass
		## 
