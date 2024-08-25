extends Node2D

@onready var scene_holder = get_node("/root/SceneManager/SceneHolder")
@onready var main_audio = get_node("/root/SceneManager/MainAudio")
@onready var main_volume_db = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))
@onready var main_animation = SceneManager.get_node("AnimationPlayer")

var tweenSound

func _ready():
	SceneManager.get_node("CanvasLayer/SceneTransition").visible = true
	main_audio.volume_db = 0.0
	load_scene("res://Scenes/MainMenu.tscn")

func load_scene(scene_path: String):
	if not SceneManager.get_node("CanvasLayer/SceneTransition").color == Color.BLACK:
		main_animation.play_backwards("TransitionScreen")
	
	while main_animation.is_playing() and main_animation.current_animation == "TransitionScreen" and main_animation.get_playing_speed() == -1.0:
		await get_tree().process_frame
		
	if scene_path != "res://Scenes.MainMeny.tscn":
		tweenSound = get_tree().create_tween()
		tweenSound.tween_method(Callable(self, "set_bus_volume_db"), main_volume_db, -80.0, 3)
		tweenSound.play()
		main_audio.stop()
	elif scene_path == "res://Scenes.MainMeny.tscn":
		main_audio.stop()
		main_audio.play(0.0)
		main_audio.seek(0.0)
		tweenSound = get_tree().create_tween()
		tweenSound.tween_method(Callable(self, "set_bus_volume_db"), main_volume_db, 0.0, 3)
		tweenSound.play()
		
	await tweenSound.finished
		
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
			
		scene_loaded(scene_instance)
	else:
		print("Failed to load scene: ", scene_path)
		
func scene_loaded(scene):
	main_animation.play("TransitionScreen")
	
func set_bus_volume_db(volume_db):
	var bus_idx = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(bus_idx, volume_db)
