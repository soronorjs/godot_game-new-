extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var Nav: NavigationAgent2D = get_node("NavigationAgent2D")
@onready var Player: CharacterBody2D = get_node("../CharacterBody2D")
@onready var line: Line2D = get_node("PlaceholderEnemy/Line2D")
@onready var shapeCast: ShapeCast2D = get_node("PlaceholderEnemy/ShapeCast2D")
@onready var rayCast: RayCast2D = get_node("PlaceholderEnemy/RayCast2D")

var Direction = Vector2.LEFT.x
var cooldown = false
var Patrol = true

const SPEED = 30.0
const JUMP_VELOCITY = -300.0

func _physics_process(delta):
	
	# Walking Logic
	if Patrol:
		velocity.x = Direction * SPEED
	elif not Patrol:
		var directionPlayer = global_position.direction_to(Player.position).x
		if global_position.distance_to(Player.position) > 34.0:
			velocity.x = directionPlayer * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Obstacle avoidance and player targeting
	if(shapeCast.is_colliding()):
		var collisionAmount = shapeCast.get_collision_count()
		for i in range(collisionAmount):
			if(shapeCast.get_collider(i).get_class() == "StaticBody2D"):
				if(global_position.distance_to(shapeCast.get_collider(i).position) <= 59.0) and (shapeCast.get_collider(i).global_position.y <= $".".position.y) and (signf(global_position.direction_to(shapeCast.get_collider(i).position).x) == Direction):
					_jump()
			while shapeCast.get_collider(i) == Player:
				Patrol = false
				break

	# Edge avoidance
	if not rayCast.is_colliding() and Patrol:
		if not cooldown:
			Direction *= -1
	
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

	elif not Patrol:
		Direction *= signf(global_position.direction_to(Player.position).y)
		print(Direction)

		line.set_point_position(0, rayCast.position)
		line.set_point_position(1, rayCast.target_position)
		
		if $".".velocity.x < 0:
			$PlaceholderEnemy.flip_h = true
			rayCast.position.x = -33
		elif $".".velocity.x > 0:
			$PlaceholderEnemy.flip_h = false
			rayCast.position.x = 33

	move_and_slide()
	
func _jump():
	if is_on_floor():
		velocity.y = JUMP_VELOCITY
		move_and_slide()
		
func wait(seconds):
	get_tree().create_timer(seconds)
