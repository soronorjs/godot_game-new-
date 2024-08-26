extends Button

@onready var AudioPlayer = SceneManager.get_node("MainAudio")
@onready var AudioVolume = AudioPlayer.volume_db

@onready var animation_player = SceneManager.get_node("AnimationPlayer")

# Called when the node enters the scene tree for the first time.
func _ready():
	AudioPlayer.play()
	$".".pressed.connect(self._button_pressed)

func _button_pressed():
	var Volume = AudioVolume
	
	SceneController.load_scene("res://Scenes/TestScene.tscn")
	SceneController.tweenSound.stop()
	SceneController.tweenSound.tween_method(Callable(SceneController, "set_bus_volume_db"), Volume, -80.0, 3)
	SceneController.tweenSound.play()
	
func _physics_process(delta):
	print(AudioServer.get_bus_volume_db(0))
	if AudioServer.get_bus_volume_db(0) == -80.0:
		AudioPlayer.stop()
		
