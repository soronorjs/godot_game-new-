extends Node

@onready var Player = %Player
@onready var HP = Player.get_meta("HP")

func _physics_process(delta):
	HP = Player.get_meta("HP")
	if HP <= 0:
		print("Ded")
		Player.position = $"../../Checkpoint".position
		Player.set_meta("HP", 100)
