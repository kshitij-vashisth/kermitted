extends State
@export var player: CharacterBody2D
#var wall_pushoff_available: bool = true
#var wall_pushoff_time = player.wall_pushback_hang_time

# wall_pushoff timer function =======================#
func wall_pushoff_timeout() -> void:
	player.wall_pushoff_available = true
func wall_pushoff_timer() -> void:
	get_tree().create_timer(player.wall_pushback_hang_time).timeout.connect(wall_pushoff_timeout)
	
func wall_gravity_act_after_push() -> void:
	get_tree().create_timer(player.wall_push_off_hang_time).timeout.connect(wall_pushoff_timeout)
	#pass
#====================================================#



func enter() -> void:
	player.canMove = true
	player.wall_pushoff_available = false
	print("sliding")

func physics_update(delta: float) -> void:
	player.jump_count = 0
	if player.look_dir < 0:
		player.isLeft = true
		player.player_sprites.flip_h = player.isLeft
	
	if player.look_dir > 0:
		player.isLeft = false
		player.player_sprites.flip_h = player.isLeft
	#player.player_sprites.flip_h = !player.isLeft
	#player.direction_collision()
	player.velocity.y = 0
	if player.velocity.y < player.slide_speed:
		if not player.has_gun:
			player.player_sprites.play("wall_slide_no_gun")
		elif player.has_gun:
			player.player_sprites.play("wall_slide")
		player.velocity.y += player.fall_gravity * delta * 0.8
	
	## --- Horizontal air control ---
	#player.air_control(delta)
	if Input.is_action_just_pressed("shoot"):
		player.on_wall_shoot_function()
	
	if Input.is_action_just_pressed("up"):
		player.change_state("wall_jump", player.state_access)
	
	#if not player.is_on_wall():
		#print("wall slide->idle")
		#state_machine.change_state("idle")
	
	#player.wall_end_fall()
	
	
	#TODO: work on wall fall off===============================>
	if not player.is_on_wall() and not player.is_on_floor():
		player.change_state("in_air", player.state_access)
	#==========================================================>
	if player.is_on_floor_only():
		print("wall slide->idle")
		player.change_state("idle", player.state_access)
	
	if Input.is_action_just_pressed("tongue_zip"):
		player.change_state("tongue_zip", state_machine)
	
	if Input.is_action_just_pressed("right") and player.is_on_wall_only():
		if not player.wall_pushoff_available:
			wall_pushoff_timer()
			player.isLeft = false
			player.player_sprites.flip_h = player.isLeft
			player.velocity.x = player.push_off
			player.air_control(delta)
			wall_gravity_act_after_push()
			player.wall_pushoff_available = false
			player.change_state("in_air", player.state_access)
	
	if Input.is_action_just_pressed("left") and player.is_on_wall_only():
		if not player.wall_pushoff_available:
			wall_pushoff_timer()
			player.isLeft = true
			player.player_sprites.flip_h = player.isLeft
			player.velocity.x = -player.push_off
			player.air_control(delta)
			wall_gravity_act_after_push()
			player.wall_pushoff_available = false
			player.change_state("in_air", player.state_access)
	
	player.move_and_slide()
