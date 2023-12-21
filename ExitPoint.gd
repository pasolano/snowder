extends Area2D

const FILE_FORMAT = "res://levels/{level}-s{screen}.tscn"

var loading_status : int
var progress : Array[float]

var target_scene_path : String
var target_scene_exists: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	var current_scene_file := get_tree().current_scene.scene_file_path
	
	# TODO horrible, but I'm assuming the level naming convention is temporary anyway
	var next_level_number := current_scene_file.split('-')[1].to_int() + 1
	
	var keys := {
		"level": 1,
		"screen": next_level_number,
		}
	target_scene_path = FILE_FORMAT.format(keys)

	# Request to load the target scene:
	target_scene_exists = FileAccess.file_exists(target_scene_path)
	if target_scene_exists:
		ResourceLoader.load_threaded_request(target_scene_path)

func _on_body_entered(body):
		if target_scene_exists and body.is_in_group("Player"):
			get_tree().call_deferred("change_scene_to_file", target_scene_path)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(_delta: float) -> void:
	## Update the status:
	#loading_status = ResourceLoader.load_threaded_get_status(target_scene_path, progress)
	#
	## Check the loading status:
	#match loading_status:
		##ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			##progress_bar.value = progress[0] * 100 # Change the ProgressBar value
		#ResourceLoader.THREAD_LOAD_LOADED:
			## When done loading, change to the target scene:
			#get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(target_scene_path))
		#ResourceLoader.THREAD_LOAD_FAILED:
			## Well some error happend:
			#print("Error. Could not load Resource")
