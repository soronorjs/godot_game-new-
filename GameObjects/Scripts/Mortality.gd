extends Node

@onready var enemyBase = $"../"
@onready var spikeDetectCast = $"../Enemy_Sprite/SpikeDetection"

func _physics_process(delta):
	if spikeDetectCast.is_colliding():
		for i in spikeDetectCast.get_collision_count():
			if spikeDetectCast.get_collider(i) == %Player and %Player.velocity.y > 0:
				%Player.set_meta("HP", 0)
