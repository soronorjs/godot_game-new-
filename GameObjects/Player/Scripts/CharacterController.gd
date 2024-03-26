extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	
	# Gravity control
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
		

	# Walking Controls
	var direction = Input.get_axis("ui_left", "ui_right")
	
	if direction:
		velocity.x = direction * SPEED
		if direction == -1:
			$Player.flip_h = true
		else:
			$Player.flip_h = false
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		$Player.play("Idle")

	move_and_slide()
