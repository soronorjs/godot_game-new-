extends CharacterBody2D


const SPEED = 30.0
const JUMP_VELOCITY = -200.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var nav: NavigationAgent2D = $NavigationAgent2D
@onready var Player: CharacterBody2D = $"../CharacterBody2D"
var safeVelocity

func _physics_process(delta):
	
	var target_velocity = Vector2(30, 0) * global_position.direction_to(Player.position)
	velocity.x = target_velocity.x
	
	var origin = Vector2(0, 0)  # Define the origin point
	var rayEndPoints = []  # Array to store end points of rays

	for i in range(20):  # Cast 20 rays
		var angle = i * (90 / 20)  # Calculate angle for each ray
		var direction = Vector2.RIGHT.rotated(angle)  # Adjust direction for each ray
		var endPoint = origin + direction * 1000  # Calculate end point
		rayEndPoints.append(endPoint)  # Store end point in the array
		
	for endPoint in rayEndPoints:
		var space_state = get_world_2d().direct_space_state
		var query = PhysicsRayQueryParameters2D.create($".".position, endPoint)
		query.exclude = [$"."]
		var result = space_state.intersect_ray(query)
		
		var line = $"../Line2D".duplicate()

		if result:
			if result.collider != $"/root/Node2D/CharacterBody2D":
				if global_position.distance_to(result.position) < 34 and is_on_floor():
					velocity.y = JUMP_VELOCITY
				
				line.set_point_position(0, $".".position)
				line.set_point_position(1, result.position)
				add_child(line)
			else:
				line.queue_free()

	
	if not is_on_floor():
		velocity.y += gravity * delta

	move_and_slide()
	
#func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	#velocity = safe_velocity
	#print(safe_velocity)
	move_and_slide()
