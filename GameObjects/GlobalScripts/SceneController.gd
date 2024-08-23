extends Node2D

@onready var scene_holder = get_node("/root/SceneManager/SceneHolder")
@onready var main_audio = get_node("/root/SceneManager/MainAudio")
@onready var main_animation = SceneManager.get_node("AnimationPlayer")

func _ready():
	SceneManager.get_node("CanvasLayer/SceneTransition").visible = true
	load_scene("res://Scenes/MainMenu.tscn")

func load_scene(scene_path: String):
	main_animation.play("TransitionScreen")
	
	if scene_holder.get_child_count() > 0:
		for child in scene_holder.get_children():
			scene_holder.remove_child(child)
			child.queue_free()
		
	var scene = load(scene_path)
	if scene:
		var scene_instance = scene.instantiate()
		scene_holder.add_child(scene_instance)
		call_deferred("scene_loaded", scene_instance)
		
		var scene_cam = scene_instance.get_node("Player/Cameras/MainCam")
	
		if scene_cam:
			scene_cam.make_current()
			print(get_viewport().get_camera_2d())
		else:
			push_error("Failed to recognize camera")
	else:
		print("Failed to load scene: ", scene_path)
		
func scene_loaded():
	print("Works!")
	main_animation.play("TransitionScreen")


func _on_animation_player_animation_finished(anim_name):
	if SceneManager.get_node("CanvasLayer/SceneTransition").color == Color.BLACK:
		main_animation.play("TransitionScreen")
