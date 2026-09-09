extends State

@export var player: CharacterBody2D
func jump():
	if player.hasGun:
		player.player_sprites.play("jump")
	elif not player.hasGun:
		player.player_sprites.play("jump_no_gun")
	player.velocity.y = player.jump_velocity

func enter() -> void:
	player.jump_sound.play()
	player.jump_count += 1
	jump()
	
func physics_update(delta: float) -> void:
	if Input.is_action_just_pressed("tongue_zip"):
		player.change_state("tongue_zip", state_machine)
	
	if Input.is_action_just_pressed("shoot"):
		player.shoot_function(0)
	
	if Input.is_action_just_released("up") and player.velocity.y < 0:
		player.velocity.y = player.jump_velocity/20
	
	# --- Horizontal air control ---
	player.flip_sprite()
	player.air_control(delta)

	# --- Gravity ---
	#player.gravity_for_jump(delta)
	player.apply_gravity(delta)

# --- Double-Jump
	if Input.is_action_just_pressed("up") and player.doubleJumpEnabled:
		player.change_state("double_jump",state_machine)
	
	if Input.is_action_just_pressed("up") and not player.doubleJumpEnabled:
		pass

	# --- Landed? ---
	if player.is_on_floor():
		player.jump_count = 0
		player.flip_sprite()
		player.change_state("idle", state_machine)
	
	# --- Wall Slide ---	
	if player.is_on_wall():
		player.change_state("wall_slide", state_machine)
		
	# --- Apply movement ---
	player.move_and_slide()
	
	
