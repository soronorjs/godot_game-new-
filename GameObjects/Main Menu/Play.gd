extends Button

@onready var AudioPlayer = SceneManager.get_node("MainAudio")
@onready var AudioVolume = AudioPlayer.volume_db

@onready var animation_player = SceneManager.get_node("AnimationPlayer")

# Called when the node enters the scene tree for the first time.
func _ready():
	AudioPlayer.play()
	$".".pressed.connect(self._button_pressed)

func _button_pressed():
	SceneController.load_scene("res://Scenes/TestScene.tscn")
	
func _physics_process(delta):
	if AudioServer.get_bus_volume_db(0) == -80.0:
		AudioServer.set_bus_volume_db(0, 0.0)
		#AudioPlayer.playing = false
		AudioPlayer.stop()
		
