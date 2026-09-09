extends State
var leftStore : bool

@export var player: CharacterBody2D
@export var ACCEL: float = 10.0
@onready var direction = player.look_dir
func enter() -> void:
	player.canMove = true
	#if player.look_dir < 0:
		#player.player_sprites.flip_h = true
	#else:
		#player.player_sprites.flip_h = false	
	#leftStore = player.playerLastLeft
	if player.hasGun:
		player.player_sprites.play("idle")
	elif !player.hasGun:
		player.player_sprites.play("idle_no_gun")
	#player.player_sprites.flip_h = leftStore

func change_to_wall_slide():
	if player.is_on_wall():
		player.change_state("wall_slide", state_machine)

func physics_update(delta: float) -> void:
	if player.look_dir < 0:
		player.player_sprites.flip_h = true
	else:
		player.player_sprites.flip_h = false
	
	#gravity
	player.apply_gravity(delta)
	
	if Input.is_action_just_pressed("tongue_zip"):
		player.change_state("tongue_zip", state_machine)
		
	# If there's input, switch to Move state
	if player.input_direction != Vector2.ZERO:
		#print("idle->move")
		#state_machine.change_state("move")
		player.change_state("move", state_machine)
		#return

	# Smoothly slow to a stop horizontally
	player.velocity.x = lerp(player.velocity.x, 0.0, ACCEL * delta)
	
	if Input.is_action_just_pressed("up") and player.is_on_floor():
		player.change_state("jump", state_machine)
	#player.jump_using_coyote_timer(state_machine)
	
	# --- Wall Slide ---	
	#change_to_wall_slide()
	
	# --- in Air ---
	if (not player.is_on_floor()) and (not player.is_on_wall()):
		player.change_state("in_air", state_machine)
	
	if Input.is_action_just_pressed("shoot"):
		player.shoot_function(player.shoot_knockback)
	
	if Input.is_action_just_pressed("down") and player.is_on_floor_only():
		player.change_state("crouch",player.state_access)
	
	# --- Apply movement ---
	player.move_and_slide()
