extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var nav: NavigationAgent2D = $NavigationAgent2D
@onready var Player: CharacterBody2D = $"../CharacterBody2D"
var safeVelocity

func _physics_process(delta):
	
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create($".".position, Player.position)
	var result = space_state.intersect_ray(query)
	
	$"../Line2D".Points[1] = $".".position
	$"../Line2D".Points[2] = Player.position
	$"../Line2D".draw()
	
	if result:
		if (result.collider is StaticBody2D):
			velocity.y = JUMP_VELOCITY
			$"../Line2D".Points[0] = $".".position
			$"../Line2D".Points[1] = Player.position
			$"../Line2D".draw()
	
	if not is_on_floor():
		velocity.y += gravity * delta
		
	print(nav.is_navigation_finished())
		
	var direction = Vector2()
	
	if (Player.position!=nav.target_position):
		nav.target_position = Player.position
	
	direction = global_position.direction_to(nav.get_next_path_position())
	direction = direction.normalized()
	
	nav.set_velocity(direction*SPEED*delta)

	move_and_slide()
	
func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	velocity = safe_velocity
	print(safe_velocity)
	move_and_slide()
