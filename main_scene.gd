extends Node

var target_scene_path = "res://1-s1.tscn"



var loading_status : int
var progress : Array[float]

# Called when the node enters the scene tree for the first time.
func _ready():	
	# Request to load the target scene:
	ResourceLoader.load_threaded_request(target_scene_path)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# Update the status:
	loading_status = ResourceLoader.load_threaded_get_status(target_scene_path, progress)
	
	# Check the loading status:
	match loading_status:
		#ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			#progress_bar.value = progress[0] * 100 # Change the ProgressBar value
		ResourceLoader.THREAD_LOAD_LOADED:
			# When done loading, change to the target scene:
			get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(target_scene_path))
		ResourceLoader.THREAD_LOAD_FAILED:
			# Well some error happend:
			print("Error. Could not load Resource")
