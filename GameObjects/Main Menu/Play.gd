extends Button


# Called when the node enters the scene tree for the first time.
func _process(delta):
	$".".pressed.connect(self._button_pressed)
	if Input.is_physical_key_pressed(KEY_ESCAPE):
		get_tree().change_scene_to_file("res://MainMenu.tscn")

func _button_pressed():
	get_tree().change_scene_to_file("res://TestScene.tscn")
