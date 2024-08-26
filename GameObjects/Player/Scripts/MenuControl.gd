extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_physical_key_pressed(KEY_ESCAPE):
		SceneController.load_scene("res://Scenes/MainMenu.tscn")
		
		var tweenSound = SceneController.tweenSound
		var volume = SceneController.main_audio.volume_db
		tweenSound.stop()
		SceneController.main_audio.play(0.0)
		tweenSound.tween_method(Callable(SceneController, "set_bus_volume_db"), volume, 0.0, 3)
		tweenSound.play()
