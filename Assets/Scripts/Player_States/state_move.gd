extends State

@export var player: CharacterBody2D

func physics_update(delta: float) -> void:
	if player.look_dir < 0:
		player.player_sprites.flip_h = true
	else:
		player.player_sprites.flip_h = false
	#player.isLeft = player.direction_calculate(player.velocity.x)
	#player.player_sprites.flip_h = player.isLeft
	if player.hasGun:
		player.player_sprites.play("walk")
	elif not player.hasGun:
		player.player_sprites.play("walk_no_gun")
	#gravity
	player.apply_gravity(delta)

	var target_x = player.input_direction.x * player.move_speed
	if player.canMove:
		player.velocity.x = lerp(player.velocity.x, target_x, player.move_accel * delta)
	
	if Input.is_action_just_pressed("up") and player.is_on_floor():
		print("move->jump")
		state_machine.change_state("jump")
	#player.jump_using_coyote_timer(state_machine)
		
	if player.input_direction.x == 0:
		player.playerLastLeft = player.isLeft
		print("move->idle")
		state_machine.change_state("idle")
	
	
	# transition to wall slide
	#if player.is_on_wall_only():
		##player.look_dir = player.direction_collision()
		#print("move->wall_slide")
		#state_machine.change_state("wall_slide")
	
	if Input.is_action_just_pressed("tongue_zip"):
		player.change_state("tongue_zip", state_machine)
		
	if Input.is_action_just_pressed("shoot"):
		player.shoot_function(player.shoot_knockback)
	
	if Input.is_action_just_pressed("down"):
		player.change_state("crouch",player.state_access)
	player.move_and_slide()
