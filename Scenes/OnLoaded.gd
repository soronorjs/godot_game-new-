extends Control

func _ready():
	var fadeTween = get_tree().create_tween()
	fadeTween.TRANS_LINEAR
	fadeTween.tween_property($Control/Fade, "color", Color.TRANSPARENT, 1)
