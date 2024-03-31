extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
const SPEED = 95.5
const JUMP_VELOCITY = -400.0

@onready var Player_Base: CharacterBody2D = get_node("%Player")
@onready var Player_Sprite: AnimatedSprite2D = get_node("Player_Sprite")

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
		Player_Sprite.play()
		velocity.x = direction * SPEED
		if direction == -1:
			Player_Sprite.flip_h = true
		else:
			Player_Sprite.flip_h = false
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		Player_Sprite.stop()
		Player_Sprite.frame = 1

	move_and_slide()
