extends Node

@onready var enemyBase = $"../"
@onready var spikeDetectCast = $"../Enemy_Sprite/SpikeDetection"

func _physics_process(delta):
	if spikeDetectCast.is_colliding():
		for i in spikeDetectCast.get_collision_count():
			if "Player" in spikeDetectCast.get_collider(i).name and spikeDetectCast.get_collider(i).velocity.y > 0:
				spikeDetectCast.get_collider(i).set_meta("HP", 0)
