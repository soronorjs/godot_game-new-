extends CanvasLayer

@onready var scene_holder = get_node("/root/SceneManager/SceneHolder")
@onready var main_audio = get_node("/root/SceneManager/MainAudio")

func _ready():
	load_scene("res://Scenes/MainMenu.tscn")

func load_scene(scene_path: String):
	if scene_holder.get_child_count() > 0:
		for child in scene_holder.get_children():
			scene_holder.remove_child(child)
			child.queue_free()
		
	var scene = load(scene_path)
	if scene:
		var scene_instance = scene.instantiate()
		scene_holder.add_child(scene_instance)
		
		var scene_cam = get_node(str("/root/SceneManager/SceneHolder/", scene_instance.name, "/Cameras/MainCam"))
	
		if scene_cam:
			scene_cam.make_current()
	else:
		print("Failed to load scene: ", scene_path)
