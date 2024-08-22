extends Camera2D


# Make sure camera is set
func _ready():
	self.make_current()
	
func _process(delta):
	$".".position = $"../../Player_Sprite".position
