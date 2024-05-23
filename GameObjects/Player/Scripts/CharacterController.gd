extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var jumps_remaining = 0
var Dash : bool
var dash_cooldown : bool = false
var wall_slide : bool = false

# Player Metadata and Nodes
@onready var Player_Base = %Player
@onready var Player_Sprite = get_node("Player_Sprite")
@onready var Dashing = Player_Base.get_meta(&"Dashing")
@onready var Speed = Player_Base.get_meta(&"Speed")
@onready var sprintSpeed = Player_Base.get_meta(&"Sprint_Speed")
@onready var dashSpeed = Player_Base.get_meta(&"Dash_Speed")
@onready var jumpVelocity = Player_Base.get_meta(&"Jump_Velocity")
@onready var doubleJump = Player_Base.get_meta(&"Double_Jump")

func _physics_process(delta):
	
	# Gravity control
	if not is_on_floor():
		velocity.y += gravity * delta
		Player_Sprite.animation = "Jump_Charge"
		Player_Sprite.frame = 4

	# Handle jump.
	
	if Input.is_action_just_pressed("ui_accept"):
		if is_on_floor():
			Player_Sprite.animation = "Jump_Charge"
			Player_Sprite.speed_scale = 0.3
			Player_Sprite.stop()
			Player_Sprite.play()
		elif jumps_remaining < 1 and doubleJump:
			velocity.y = jumpVelocity
			jumps_remaining += 1
	
	while Input.is_action_pressed("ui_accept") and is_on_floor():
		velocity.y = jumpVelocity
		break

	if Input.is_action_just_released("ui_accept"):
		velocity.y = lerp(velocity.y, gravity*delta, 0.5)
		
	if is_on_floor() and jumps_remaining > 0:
		jumps_remaining = 0
	
	var direction = Input.get_axis("ui_left", "ui_right")
	
	# Dashing Logic
	if Input.is_action_just_pressed("Dash") and Dashing and not dash_cooldown and not is_on_wall():
		var dash_direction
		
		if direction:
			dash_direction = direction * dashSpeed
		else:
			if Player_Sprite.flip_h:
				dash_direction = dashSpeed * -1
			else:
				dash_direction = dashSpeed * 1
				
		Dash = true
		dash_cooldown = true
		
		Player_Base.set_collision_layer_value(1, 0)
		Player_Base.set_collision_mask_value(1, 0)
		
		velocity.x = dash_direction
		
		await wait(0.2)
		Player_Base.set_collision_layer_value(1, 1)
		Player_Base.set_collision_mask_value(1, 1)
		
		Dash = false
		disable_cooldown()
		
	if Dash:
		$Label.label_settings.font_color = Color.RED
	elif not dash_cooldown and not Dash:
		$Label.label_settings.font_color = Color.WHITE
	
	# Wall Slide Logic
	
	if is_on_wall_only():
		if not Input.is_action_pressed("ui_accept"):
			velocity.y = lerp(velocity.y, gravity*delta, 0.25)
		jumps_remaining = 0
		wall_slide = true
	
	if Input.is_action_just_pressed("ui_accept") and wall_slide:
		velocity.y = jumpVelocity
		velocity.x = direction * Speed * 2
		Player_Sprite.flip_h = not Player_Sprite.flip_h
		if Player_Sprite.flip_h:
			direction = -1
		else:
			direction = 1
		
	if Input.is_action_just_released("ui_accept") and wall_slide:
		wall_slide = false
	
	# Walking Logic
	
	if direction and not Dash:
		if is_on_floor():
			Player_Sprite.animation = "Walk"
			Player_Sprite.speed_scale = 0.2
			Player_Sprite.play()
			
		if Input.is_action_pressed("Sprint"):
			velocity.x = direction * sprintSpeed
		else:
			velocity.x = direction * Speed
			
		if direction == -1:
			Player_Sprite.flip_h = true
			$CollisionShape2D.position.x = 0
		else:
			Player_Sprite.flip_h = false
			$CollisionShape2D.position.x = 4
	else:
		if not Dash and not wall_slide:
			velocity.x = move_toward(velocity.x, 0, Speed)
			if is_on_floor():
				Player_Sprite.animation = "Idle"
				Player_Sprite.speed_scale = 0.33
				Player_Sprite.play()

	move_and_slide()
	
func wait(seconds):
	await get_tree().create_timer(seconds).timeout
	
func disable_cooldown():
	if dash_cooldown:
		await wait(1.5)
		dash_cooldown = false
