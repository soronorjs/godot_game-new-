extends Node2D

@onready var scene_holder = get_node("/root/SceneManager/SceneHolder")
@onready var main_audio = get_node("/root/SceneManager/MainAudio")
@onready var main_animation = SceneManager.get_node("AnimationPlayer")

func _ready():
	await load_scene("res://Scenes/MainMenu.tscn")
	main_animation.play("TransitionScreen")

func load_scene(scene_path: String):
	main_animation.play_backwards("TransitionScreen")
	
	if scene_holder.get_child_count() > 0:
		for child in scene_holder.get_children():
			scene_holder.remove_child(child)
			child.queue_free()
		
	var scene = load(scene_path)
	if scene:
		var scene_instance = scene.instantiate()
		scene_holder.add_child(scene_instance)
		
		var scene_cam = scene_instance.get_node("Player/Cameras/MainCam")
	
		if scene_cam:
			scene_cam.make_current()
			print(get_viewport().get_camera_2d())
		else:
			push_error("Failed to recognize camera")
		
		if not main_animation.is_playing():
			main_animation.play("TransitionScreen")
	else:
		print("Failed to load scene: ", scene_path)
