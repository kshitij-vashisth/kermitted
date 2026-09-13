extends State

@export var player: CharacterBody2D
func enter() -> void:
	player.canMove = true

func physics_update(delta: float) -> void:
	#if player.look_dir < 0:
		#player.player_sprites.flip_h = true
	#else:
		#player.player_sprites.flip_h = false
	player.apply_gravity(delta)
	if not player.has_gun:
		player.player_sprites.play("jump_no_gun")
	elif player.has_gun:
		player.player_sprites.play("jump")
	#player.isLeft = player.direction_calculate(player.velocity.x)
	#player.player_sprites.flip_h = player.isLeft
	player.air_control(delta)
	
	if Input.is_action_just_pressed("up") and player.doubleJumpEnabled:
		#player.playerLastLeft = !player.isLeft
		player.change_state("double_jump",state_machine)
	
	# switch to wall slide
	if player.is_on_wall():
		player.playerLastLeft = player.isLeft
		player.change_state("wall_slide", state_machine)
	
	if Input.is_action_just_pressed("shoot"):
		player.shoot_function(0)
	
	# switch to idle
	if player.is_on_floor():
		#player.playerLastLeft = player.isLeft
		player.change_state("idle", state_machine)

	player.move_and_slide()
