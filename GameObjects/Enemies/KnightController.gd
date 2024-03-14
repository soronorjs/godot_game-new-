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
	pass

func _physics_process(delta):
	
	var target_velocity = Vector2(30, 0) * global_position.direction_to(Player.position)
	velocity.x = target_velocity.x

	
	if not is_on_floor():
		velocity.y += gravity * delta
		
	for i in range(20):
		var space_state = get_world_2d().direct_space_state
		var query = PhysicsRayQueryParameters2D.create(global_position, Vector2(20,0).rotated(deg_to_rad(360*i)))
		query.exclude = [$"."]
		var result = space_state.intersect_ray(query)
		
		if result:
			var lineClone = line.duplicate()
			lineClone.set_point_position(0, Vector2(0,0))
			lineClone.set_point_position(1, result.position)
			add_child(lineClone)

	move_and_slide()
	
#func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	#velocity = safe_velocity
	#print(safe_velocity)
	move_and_slide()
