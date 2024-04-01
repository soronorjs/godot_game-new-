extends CharacterBody2D

<<<<<<< HEAD
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
const SPEED = 95.5
=======

const SPEED = 150.0
>>>>>>> 93b984eca940017b89d3b740d50ef9fd9cd6a552
const JUMP_VELOCITY = -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var Dashing = $".".get_meta(&"Dashing")

func _physics_process(delta):
	
	# Gravity control
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Walking Controls
	var direction = Input.get_axis("ui_left", "ui_right")
	
	if Input.is_action_just_pressed("Dash"):
		if $Player_Sprite.flip_h == true:
			$RayCast2D.target_position.x = -50
			if not $RayCast2D.is_colliding():
				%Player.position.x += 50 * -1
			else:
				%Player.position.x += global_position.distance_to($RayCast2D.get_collision_point())
		else:
			$RayCast2D.target_position.x = 50
			if not $RayCast2D.is_colliding():
				%Player.position.x += 50 * 1
			else:
				%Player.position.x += global_position.distance_to($RayCast2D.get_collision_point())
	
	if direction:
<<<<<<< HEAD
		Player_Sprite.play()
		velocity.x = direction * SPEED
		if direction == -1:
			Player_Sprite.flip_h = true
			$CollisionShape2D.position.x = 0
		else:
			Player_Sprite.flip_h = false
			$CollisionShape2D.position.x = 4
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		Player_Sprite.stop()
		Player_Sprite.frame = 1
=======
		print($RayCast2D.is_colliding())
		velocity.x = direction * SPEED
		if direction == -1:
			$Player_Sprite.flip_h = true
		else:
			$Player_Sprite.flip_h = false
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		$Player_Sprite.play("Idle")
>>>>>>> 93b984eca940017b89d3b740d50ef9fd9cd6a552

	move_and_slide()
