extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var jumps_remaining = 0
var Dash : bool
var dash_cooldown : bool = false
var wall_slide : bool = false
var no_jump : bool = false

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
	
	if Input.is_action_just_pressed("ui_accept") and jumps_remaining < 1:
		if is_on_floor():
			Player_Sprite.animation = "Jump_Charge"
			Player_Sprite.speed_scale = 0.3
			Player_Sprite.stop()
			Player_Sprite.play()
		elif jumps_remaining < 1 and doubleJump:
			velocity.y = jumpVelocity
			jumps_remaining += 1
	
	while Input.is_action_pressed("ui_accept") and is_on_floor() and jumps_remaining < 1:
		velocity.y = jumpVelocity
		break

	if Input.is_action_just_released("ui_accept") and not no_jump:
		velocity.y = lerp(velocity.y, gravity*delta, 0.75)
		if jumps_remaining >= 1 and not no_jump:
			no_jump = true
		
	if is_on_floor() or is_on_wall_only() and jumps_remaining > 0:
		jumps_remaining = 0
		no_jump = false
	
<<<<<<< HEAD
	# Dashing Logic
	if Input.is_action_just_pressed("Dash") and Dashing and not is_on_wall():
		if Player_Sprite.flip_h == true:
			$RayCast2D.target_position.x = -50
			Player_Base.position.x = $RayCast2D.position.x
		else:
			$RayCast2D.target_position.x = 50
			Player_Base.position.x = $RayCast2D.position.x
=======
	var direction = Input.get_axis("ui_left", "ui_right")
	
	# Dashing Logic
	dash(direction)
		
	if Dash:
		$Label.label_settings.font_color = Color.RED
	elif not dash_cooldown and not Dash:
		$Label.label_settings.font_color = Color.WHITE
	
	# Wall Slide Logic
	
	if is_on_wall_only():
		while not Input.is_action_pressed("ui_accept"):
			var lerp
			if not Input.is_action_pressed("ui_down"):
				lerp = lerp(velocity.y, gravity*4*delta, 0.25)
			elif Input.is_action_pressed("ui_down"):
				lerp = lerp(velocity.y, gravity*14*delta, 0.25)
			velocity.y = lerp
			break
		wall_slide = true
		disable_cooldown()
	
	if Input.is_action_just_pressed("ui_accept") and wall_slide or Input.is_action_just_pressed("Dash") and wall_slide:
		if Input.is_action_just_pressed("ui_accept"):
			Player_Sprite.flip_h = not Player_Sprite.flip_h
		if Player_Sprite.flip_h:
			direction = -1
		else:
			direction = 1
		if Input.is_action_just_pressed("ui_accept"):
			velocity.y = jumpVelocity
			velocity.x = direction * Speed
		
	if Input.is_action_just_released("ui_accept") and wall_slide or is_on_floor() and wall_slide or Input.is_action_just_released("Dash") and wall_slide:
		wall_slide = false
		velocity.y = lerp(velocity.y, gravity*delta, 0.5)
		velocity.x = move_toward(velocity.x, 0, Speed)
			
>>>>>>> e346d73b59a0f6eb9109e8ec2c3f2c95eca8fdeb
	
	# Walking Logic
	
	if direction and not Dash:
		if is_on_floor():
			Player_Sprite.animation = "Walk"
			Player_Sprite.speed_scale = 0.2
			Player_Sprite.play()
			
		if wall_slide:
			if Player_Sprite.flip_h == true:
				direction = -1
			else:
				direction = 1
			
		if Input.is_action_pressed("Sprint"):
			velocity.x = direction * sprintSpeed
		else:
			velocity.x = direction * Speed
			
		if direction == -1 and not wall_slide:
			Player_Sprite.flip_h = true
			$CollisionShape2D.position.x = 0
		elif direction == 1 and not wall_slide:
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
	
<<<<<<< HEAD
func is_point_inside_object(point, object):
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_point(point, 32)
	return result.size() > 0
=======
func wait(seconds):
	await get_tree().create_timer(seconds).timeout
	
func disable_cooldown():
	if dash_cooldown:
		await wait(1)
		dash_cooldown = false
		
func dash(direction):
	# Dashing Logic
	if Input.is_action_just_pressed("Dash") and Dashing and not dash_cooldown:
		var dash_direction
		
		if direction and not wall_slide:
			dash_direction = direction * dashSpeed
		elif wall_slide:
			Player_Sprite.flip_h = not Player_Sprite.flip_h
			if Player_Sprite.flip_h:
				direction = -1
			else:
				direction = 1
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
>>>>>>> e346d73b59a0f6eb9109e8ec2c3f2c95eca8fdeb
