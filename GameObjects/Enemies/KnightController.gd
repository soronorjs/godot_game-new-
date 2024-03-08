extends CharacterBody2D


const SPEED = 3000.0
const JUMP_VELOCITY = -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var nav: NavigationAgent2D = $NavigationAgent2D
@onready var Player: CharacterBody2D = $"../CharacterBody2D"

func _physics_process(delta):
	
	var direction = Vector2()
	
	nav.target_position = Player.position
	
	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()
	print(global_position)
	
	velocity = velocity.lerp(direction*SPEED, 7*delta)
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
	

	move_and_slide()
