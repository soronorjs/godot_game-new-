extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

const SPEED = 95.5
const JUMP_VELOCITY = -400.0

@onready var Player_Base = %Player
@onready var Dashing = Player_Base.get_meta(&"Dashing")
@onready var Player_Sprite = get_node("Player_Sprite")

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

	move_and_slide()
