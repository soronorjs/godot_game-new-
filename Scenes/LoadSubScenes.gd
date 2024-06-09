extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var ui = preload("res://Scenes/game_ui.tscn")
	
	var UI_instance = ui.instantiate()
	UI_instance.set_position(%Player.position)
	add_child(UI_instance)
	
	print(get_children())
