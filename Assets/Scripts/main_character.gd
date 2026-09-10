extends CharacterBody2D
var hasGun: bool = true
var stored_sign_x_velocity: int = 0
var toBounce: bool = false
@export var firing_light_value: float = 20.0
var bullet = preload("res://Assets/Elements/bullet.tscn")
var shell = preload("res://Assets/Elements/Shell.tscn")
@onready var muzzle: Marker2D = %Muzzle
var muzzle_position
@export var shoot_knockback: int = 5
var jump_count: int = 0
var isLeft: bool
#var isDead: bool = false
@export var doubleJumpEnabled: bool = false
var canMove: bool = true
var playerLastLeft: bool
var look_dir: int = 1
@export var player_sprites :AnimatedSprite2D
@export var slide_speed: int = 4000
var input_direction = Vector2.ZERO
var last_direction: float
@export var game_manager: Node
@export var move_speed: float = 200.0
@export var move_accel: float = 15.0

@export var hurt_velocity_y: float = 200.0
@export var zip_range: float = 200.0
@export var tongue_release_multiplier: float = 1.0

@onready var tongue_ray_cast: RayCast2D = %TongueRayCast
@onready var tongue_line: Line2D = %TongueLine
@onready var aim_line: Line2D = %AimLine

@export var shoot_light: PointLight2D

#sfx/bgm=======================================================>
@export var jump_sound: AudioStreamPlayer
@export var player_hurt_sound: AudioStreamPlayer
@export var sfx_defeat: AudioStreamPlayer
@export var sfx_normal_bullet: AudioStreamPlayer
#==============================================================>




# finer parameters for smoother movement=====================================#
var wall_pushoff_available: bool = true
@export var hang_time: float = 0.15
@export var coyote_time: float
@export var wall_pushback_hang_time: float = 0.15
@export var wall_push_off_hang_time: float = 0.25
#============================================================================#

# air maneuverability parameters=============================================#
@export var air_accel: float = 10.0
@export var push_off: float = 20.0
#============================================================================#


func clear_tongue() -> void:
	tongue_line.visible = false
	tongue_line.clear_points()

func player_dying() -> void:
	player_sprites.play("destroyed")
	hide()

func hurt()-> void:
	#velocity.y += -hurt_velocity_y
	#velocity.x += -look_dir*2500 
	player_sprites.play("hurt")
	#player_hurt_sound.play()

func hurt_and_knockback(x_delta: float, game_manager: Node, playerHurtDamage: int) -> void:
	var knock_dir = sign(x_delta)  # +1 if player is to the right of mushroom, -1 if left
	if knock_dir == 0:
		knock_dir = 1 if isLeft else -1  # pick a default based on facing
	velocity.x = knock_dir * 2500
	change_state("hurt", state_access)
	game_manager.decrease_health(playerHurtDamage)

#func check_look_dir() -> void:
	#var dir_check: int
	#dir_check = 0
	#if look_dir != dir_check:
		#print(look_dir)
		#dir_check = look_dir

func velocity_sign_handler()-> int:
	if not velocity.x == 0:
		stored_sign_x_velocity = sign(velocity.x)
	return stored_sign_x_velocity


func is_left_calculate()-> bool:
	var yesLeft: bool = false
	if input_direction.x < 0:
		yesLeft = true
		look_dir = sign(input_direction.x)
	elif input_direction.x > 0:
		yesLeft = false
		look_dir = sign(input_direction.x)
	elif stored_sign_x_velocity < 0:
		yesLeft = true
		look_dir = stored_sign_x_velocity
	elif stored_sign_x_velocity > 0:
		yesLeft = false 
		look_dir = stored_sign_x_velocity
	else:
		yesLeft = false
		look_dir = 1
	return yesLeft


func flip_sprite() -> void:
	
	isLeft = is_left_calculate()
	player_sprites.flip_h = isLeft

# finer movement functions===================================================#
#func coyote_checker(_was_on_floor: bool) -> void:
	##if was_on_floor and !is_on_floor():
		##coyote_timer.start()
	#pass
		
func jump_using_coyote_timer(_state_machine) -> void:
	#if Input.is_action_just_pressed("up") and (is_on_floor() or coyote_timer.is_stopped()):
		#change_state("jump", state_machine)
	pass
#============================================================================#

#wall_checker_ray casts------------------------------------------------------#
@onready var wall_check_left: RayCast2D = %wall_direction_checker_left       #
@onready var wall_check_right: RayCast2D = %wall_direction_checker_right     #
#----------------------------------------------------------------------------#
@export var knockback_velocity: float = 1000.0
#gravity_parameters_for jump---------------------------------------------------------------------------------------#
@export var jump_height : float
@export var jump_time_to_peak : float
@export var jump_time_to_descent : float

@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0
@export  var state_access : StateMachine
#-------------------------------------------------------------------------------------------------------------------#


#Functions======================================================================================================#
func wall_end_fall()->void:
	if isLeft and not wall_check_left.is_colliding():
		change_state("in_air", state_access)
	
	if !isLeft and not wall_check_right.is_colliding():
		change_state("in_air", state_access)

#function to change state
func change_state(desired_state_name: String, state_machine):
	print("changing state")
	clear_tongue()
	var current_state_name = str(state_access.current_state)
	print(current_state_name.substr(0,current_state_name.find(":")).to_lower()+"->"+desired_state_name)
	state_machine.change_state(desired_state_name)

func jump()-> void:
	change_state("jump", state_access)

# orients face for wall jumps and wall slides===#
func face_orientation() -> void:
	if velocity.x != 0:	
		look_dir = sign(velocity.x)
	else:
		look_dir = stored_sign_x_velocity
#================================================#

# air control function==========================================#
func air_control(delta: float) -> void:
	var input_x = input_direction.x
	var target_x = input_x * move_speed  # use your player's SPEED
	velocity.x = lerp(velocity.x, target_x, air_accel * delta)
	if velocity.x < 0:
		playerLastLeft = true
	elif velocity.x > 0:
		playerLastLeft = false
#===============================================================#

# Functions for handling gravity==============================#
func gravity_get() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity
	
func apply_gravity(delta) -> void:
	if not is_on_floor():
		velocity.y += gravity_get() * delta

func direction_calculate(x_velocity: float) -> bool:
	var PlayerisLeft: bool = x_velocity < 0
	return PlayerisLeft

func gravity_for_jump(delta) -> void:
	velocity.y += gravity_get() * delta
# End of functions for handling gravity=======================#
func player_muzzle_position() -> void:
	if look_dir > 0:
		muzzle.position.x = muzzle_position.x
	elif look_dir < 0:
		muzzle.position.x = -muzzle_position.x

func player_muzzle_position_on_wall() -> void:
	if look_dir > 0:
		muzzle.position.x = -muzzle_position.x
	elif look_dir < 0:
		muzzle.position.x = muzzle_position.x


func bullet_and_shell_instance(direction: int)-> void:
	sfx_normal_bullet.play()
	var shell_instance = shell.instantiate() as Node2D
	var bullet_instance = bullet.instantiate() as Node2D
	bullet_instance.direction = direction * look_dir
	shell_instance.direction = - bullet_instance.direction
	shell_instance.global_position = muzzle.global_position
	bullet_instance.global_position = muzzle.global_position
	get_parent().add_child(shell_instance)
	get_parent().add_child(bullet_instance)

func shoot_function(recoil_value: int) -> void:
	if hasGun:
		player_muzzle_position()
		
		shoot_light.global_position = muzzle.global_position
		shoot_light.energy = firing_light_value

		var tween = create_tween()
		tween.tween_property(shoot_light, "energy", 0.0, 0.08)
		
		sfx_normal_bullet.play()
		bullet_and_shell_instance(1) #1 specifies direction
		#recoil on ground
		shooting_knockback(recoil_value)
	else:
		pass
	
func on_wall_shoot_function() -> void:
	if hasGun:
		player_muzzle_position_on_wall()
		
		shoot_light.global_position = muzzle.global_position
		shoot_light.energy = firing_light_value

		var tween = create_tween()
		tween.tween_property(shoot_light, "energy", 0.0, 0.08)
		# initialise bullet and shell
		bullet_and_shell_instance(-1) #-1 specifies opposite direction of where player sprite looks
	else:
		pass

func shooting_knockback(shoot_knockback: int)->void:
	if look_dir > 0:
			position.x -= shoot_knockback
	else:
		position.x += shoot_knockback

func _special_reload() -> void:
		get_tree().reload_current_scene()

# End of functions==============================================================================================#
func _ready() -> void:
	shoot_light.energy = 0.0
	#coyote_timer.wait_time = coyote_time 
	muzzle_position = muzzle.position

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("reload_scene") and OS.is_debug_build():
		call_deferred("_special_reload")
	if toBounce:
		change_state("bounce", state_access)
	#if Input.is_action_just_pressed("shoot"):
		#shoot_function()
	is_left_calculate()
	velocity_sign_handler()
	var lastLives: int = GameManager.lives
	#orients face for wall jumps and wall slides===#
	#face_orientation()
	#==============================================#
	
	#if GameManager.lives < lastLives:
		#isDead = true
		#dead()
	
	
	if is_on_floor():
		jump_count = 0
	input_direction.x = Input.get_axis("left", "right")
	#input_direction.y = Input.get_axis("up", "down")
	var was_on_floor: bool = is_on_floor()
	#coyote_checker(was_on_floor)

func _process(_delta):
	var mouse_position := get_global_mouse_position()
	var tongue_direction := global_position.direction_to(mouse_position)
	aim_line.points = PackedVector2Array([
		aim_line.to_local(global_position),
		aim_line.to_local(global_position + tongue_direction * 1000.0)
	])
