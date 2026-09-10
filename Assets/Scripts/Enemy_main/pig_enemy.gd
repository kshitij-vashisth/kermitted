extends CharacterBody2D
@export var chase_speed_multiplier: int = 2
@export var player: CharacterBody2D
@export var collider1: CollisionShape2D
@export var collider2: CollisionShape2D
@export var pointsEnabled: bool = true
@export var SPEED: float = 300.0
@export var bullet_death_sound: AudioStreamPlayer
#@export var player_bounce_velocity: float = 400.0
@export var sprite:AnimatedSprite2D
@export var ground_check: RayCast2D
@export var squash_sound: AudioStreamPlayer2D
@export var can_move: bool = true
@export var state_access: StateMachine 
@export var points: int = 30
@onready var game_manager: Node = %GameManager
@export var health: int = 3
@export var isInvincible: bool = false
@export var playerHurtDamage: int = 2


@onready var get_player: RayCast2D = $GetPlayer
@onready var timer: Timer = $Timer
var dying: bool = false
var direction: int = -1
#@onready var current_state_name = str(state_access.current_state)
#@onready var current_state = current_state_name.substr(0,current_state_name.find(":")).to_lower()
@export var at_edge: bool = false

var waiting_at_edge: bool = false

func stop_at_edge() -> void:
	at_edge = not ground_check.is_colliding()

func update_direction_visuals():
	get_player.scale.x *= -1
	sprite.scale.x *= -1
	


func change_state(desired_state_name: String, state_machine):
		#var current_state_name = str(state_access.current_state)
		state_machine.change_state(desired_state_name)

func squash() -> void:
	squash_sound.play()
	sprite.scale.y = 0.5
	sprite.position.y += 23

func enemy_dead() -> void:
	change_state("death", state_access)

func add_gravity(delta: float) -> void:
	velocity += get_gravity() * delta
	
func move_enemy()->void:
	velocity.x = SPEED * direction
	sprite.play("walk") 
	
func platform_edge()->void:
	if not ground_check.is_colliding():
		direction = -direction
		ground_check.position.x *= -1
		update_direction_visuals()
		
		
#Chase functions=================================================>
func look_for_player() -> void:
	if get_player.is_colliding():
		var collider = get_player.get_collider()
		if collider == player:
			change_state("chase", state_access)

func player_left() -> void:
		var collider = get_player.get_collider()
		if not collider == player:
			await get_tree().create_timer(1.7).timeout
			change_state("wander", state_access)

func chase_player() -> void:
	var last_direction = direction
	if player:
		direction = sign(player.global_position.x - global_position.x)
		if last_direction != direction:
			last_direction = direction
			update_direction_visuals()
	if not at_edge:
		velocity.x = chase_speed_multiplier * SPEED * direction
		
	else:
		stop_chase()
		await get_tree().create_timer(0.7).timeout
		change_state("wander", state_access)

	# Reached edge
	if at_edge:
		stop_chase()

		if not waiting_at_edge:
			waiting_at_edge = true
			await get_tree().create_timer(0.7).timeout

			# Make sure we're still in this state
			if waiting_at_edge:
				waiting_at_edge = false
				change_state("wander", state_access)
	
		return


func stop_chase() -> void:
	velocity.x = 0

#===================================================================>





func _on_area_2d_body_entered(body: Node2D) -> void:
	print("pig hit")
	if body.is_in_group("emcee"):
		print("player hit by pig")
		var y_delta: float = position.y - body.position.y
		var x_delta: float = body.position.x - position.x
		
		if abs(x_delta) > 0 and not dying:
			body.hurt_and_knockback(x_delta, game_manager, playerHurtDamage)

func _physics_process(delta: float) -> void:
	stop_at_edge()
