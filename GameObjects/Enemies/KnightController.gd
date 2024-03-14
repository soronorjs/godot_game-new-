extends CharacterBody2D


const SPEED = 30.0
const JUMP_VELOCITY = -200.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var nav: NavigationAgent2D = $NavigationAgent2D
@onready var Player: CharacterBody2D = $"../CharacterBody2D"
@onready var line: Line2D = $"../Line2D"
var safeVelocity

var rayDirections = []

func _ready():
	for i in range(20):
		var angle = i * 1
		var direction = Vector2.LEFT.rotated(deg_to_rad(angle))
		
		rayDirections.append(direction)

func _physics_process(delta):
	
	var target_velocity = Vector2(30, 0) * global_position.direction_to(Player.position)
	velocity.x = target_velocity.x

	
	if not is_on_floor():
		velocity.y += gravity * delta
		
	for i in range(20):
		var space_state = get_world_2d().direct_space_state
		var query = PhysicsRayQueryParameters2D.create(global_position, rayDirections[i])
		query.exclude = [$"."]
		
		var result = space_state.intersect_ray(query)
		var lineCopy = line.duplicate()
		add_child(lineCopy)
		
		if result:
			lineCopy.set_point_position(0, global_position)
			lineCopy.set_point_position(1, result.position)

	move_and_slide()
	
#func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	#velocity = safe_velocity
	#print(safe_velocity)
	move_and_slide()
