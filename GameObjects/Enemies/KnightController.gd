extends CharacterBody2D


const SPEED = 30.0
const JUMP_VELOCITY = -300.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var nav: NavigationAgent2D = $NavigationAgent2D
@onready var Player: CharacterBody2D = $"../CharacterBody2D"
@onready var line: Line2D = $PlaceholderEnemy/Line2D
@onready var shapeCast: ShapeCast2D = $PlaceholderEnemy/ShapeCast2D
@onready var rayCast: RayCast2D = $PlaceholderEnemy/RayCast2D

var safeVelocity

var rayDirections = []
var lines = []
var Direction = Vector2.LEFT.x
var cooldown = false

func _physics_process(delta):
	
	velocity.x = Direction * SPEED

	if not is_on_floor():
		velocity.y += gravity * delta
		
	var space_state = get_world_2d().direct_space_state
	
	if(shapeCast.is_colliding()):
		var collisionAmount = shapeCast.get_collision_count()
		for i in range(collisionAmount):
			if(shapeCast.get_collider(i).get_class() == "StaticBody2D"):
				if(global_position.distance_to(shapeCast.get_collider(i).position) <= 59.0) and (shapeCast.get_collider(i).position.y >= $".".position.y):
					_jump()

	if not rayCast.is_colliding():
		if not cooldown:
			Direction *= -1
			print(Direction)
	
			line.set_point_position(0, rayCast.position)
			line.set_point_position(1, rayCast.target_position)
			
			if Direction == -1:
				$PlaceholderEnemy.flip_h = true
				rayCast.position.x = -33
			elif Direction == 1:
				$PlaceholderEnemy.flip_h = false
				rayCast.position.x = 33
			
			cooldown = true
		elif cooldown:
			wait(1)
			cooldown = false
	

	move_and_slide()
	
func _jump():
	if is_on_floor():
		velocity.y = JUMP_VELOCITY
		move_and_slide()
		
func wait(seconds):
	get_tree().create_timer(seconds)
	
#func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	#velocity = safe_velocity
	#print(safe_velocity)
	move_and_slide()
