extends Button

@onready var AudioPlayer = SceneManager.get_node("MainAudio")
@onready var AudioVolume = AudioPlayer.volume_db

@onready var animation_player = SceneManager.get_node("AnimationPlayer")

# Called when the node enters the scene tree for the first time.
func _ready():
	$".".pressed.connect(self._button_pressed)

func _button_pressed():
	var tweenSound = get_tree().create_tween()
	tweenSound.tween_method(Callable(self, "set_bus_volume_db"), 0.0, -20.0, 3)
	
	SceneController.load_scene("res://Scenes/TestScene.tscn")

func set_bus_volume_db(volume_db):
	var bus_idx = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(bus_idx, volume_db)
	
func _physics_process(delta):
	if AudioServer.get_bus_volume_db(0) == -20.0:
		AudioServer.set_bus_volume_db(0, 0.0)
		AudioPlayer.playing = false
		
