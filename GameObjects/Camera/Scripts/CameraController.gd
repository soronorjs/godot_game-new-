extends Camera2D


# Make sure camera is set
func _ready():
	$".".make_current()
	
func _process(delta):
	$".".position = %Player.position
