extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_physical_key_pressed(KEY_ESCAPE):
		get_tree().change_scene_to_file("res://MainMenu.tscn")
