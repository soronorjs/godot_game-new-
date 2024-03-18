extends CharacterBody2D


const SPEED = 30.0
const JUMP_VELOCITY = -300.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var nav: NavigationAgent2D = $NavigationAgent2D
@onready var Player: CharacterBody2D = $"../CharacterBody2D"
@onready var line: Line2D = $"../Line2D"
@onready var shapeCast: ShapeCast2D = $ShapeCast2D

var safeVelocity

var rayDirections = []
var lines = []
var Direction = Vector2.LEFT.x

func _physics_process(delta):

	if not is_on_floor():
		velocity.y += gravity * delta
		
	var space_state = get_world_2d().direct_space_state
			
	if not is_on_floor():
		velocity.x = Direction * SPEED
		print("Idiot")
	
	if(shapeCast.is_colliding()):
		var collisionAmount = shapeCast.get_collision_count()
		for i in range(collisionAmount):
			if(shapeCast.get_collider(i).get_class() == "StaticBody2D"):
				print(global_position.distance_to(shapeCast.get_collider(i).position))
				if(global_position.distance_to(shapeCast.get_collider(i).position) <= 59.0) and (shapeCast.get_collider(i).position.y >= $".".position.y):
					print(shapeCast.get_collider(i).position.y)
					print($".".position.y)
					_jump()
	
	

	move_and_slide()
	
func _jump():
	if is_on_floor():
		velocity.y = JUMP_VELOCITY
		move_and_slide()
	
#func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	#velocity = safe_velocity
	#print(safe_velocity)
	move_and_slide()


func _on_area_2d_2_body_exited(body):
	while not shapeCast.is_colliding():
		if Direction == Vector2.LEFT.x:
			Direction = Vector2.RIGHT.x
			break
		elif Direction == Vector2.RIGHT.x:
			Direction == Vector2.LEFT.x
			break
