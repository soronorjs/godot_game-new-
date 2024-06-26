extends Button

@onready var AudioPlayer = $"../../../AudioStreamPlayer"
@onready var AudioVolume = AudioPlayer.volume_db

# Called when the node enters the scene tree for the first time.
func _ready():
	$".".pressed.connect(self._button_pressed)

func _button_pressed():
	var tweenSound = get_tree().create_tween()
	tweenSound.tween_method(Callable(self, "set_bus_volume_db"), 0.0, -20.0, 3)
	
	var tweenFade = get_tree().create_tween()
	tweenFade.TRANS_LINEAR
	tweenFade.tween_property($"../../Fading", "color", Color.BLACK, 1)

func set_bus_volume_db(volume_db):
	var bus_idx = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(bus_idx, volume_db)
	
func _physics_process(delta):
	if AudioServer.get_bus_volume_db(0) == -20.0:
		AudioServer.set_bus_volume_db(0, 0.0)
		AudioPlayer.playing = false
		$"../../Fading".color = Color.TRANSPARENT
		get_tree().change_scene_to_file("res://Scenes/TestScene.tscn")
		
