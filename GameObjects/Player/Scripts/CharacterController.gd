extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var Player_Base = %Player
@onready var Player_Sprite = get_node("Player_Sprite")
@onready var Dashing = Player_Base.get_meta(&"Dashing")
@onready var Speed = Player_Base.get_meta(&"Speed")
@onready var jumpVelocity = Player_Base.get_meta(&"Jump_Velocity")

func _physics_process(delta):
	
	# Gravity control
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	while Input.is_action_pressed("ui_accept") and is_on_floor():
		velocity.y = jumpVelocity
		break

	if Input.is_action_just_released("ui_accept"):
		velocity.y = lerp(velocity.y, gravity*delta, 0.5)

	# Walking Controls
	var direction = Input.get_axis("ui_left", "ui_right")
	
	if Input.is_action_just_pressed("Dash"):
		if Player_Sprite.flip_h == true:
			$RayCast2D.target_position.x = -50
			if not $RayCast2D.is_colliding():
				Player_Base.position.x += 50 * -1
			else:
				Player_Base.position.x += global_position.distance_to($RayCast2D.get_collision_point())
		else:
			$RayCast2D.target_position.x = 50
			if not $RayCast2D.is_colliding():
				Player_Base.position.x += 50 * 1
			else:
				Player_Base.position.x += global_position.distance_to($RayCast2D.get_collision_point())
	
	if direction:
		Player_Sprite.animation = "Walk"
		Player_Sprite.speed_scale = 0.13
		Player_Sprite.play()
		velocity.x = direction * Speed
		if direction == -1:
			Player_Sprite.flip_h = true
			$CollisionShape2D.position.x = 0
		else:
			Player_Sprite.flip_h = false
			$CollisionShape2D.position.x = 4
	else:
		velocity.x = move_toward(velocity.x, 0, Speed)
		Player_Sprite.animation = "Idle"
		Player_Sprite.speed_scale = 0.33
		Player_Sprite.play()

	move_and_slide()
	
	
func wait(seconds):
	get_tree().create_timer(seconds)
