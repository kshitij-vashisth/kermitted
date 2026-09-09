extends CharacterBody2D
class_name PigEnemy
@onready var game_manager: Node = %GameManager
@export var playerHurtDamage: int = 2
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
@export var move_speed: float = 300.0
@export var player: CharacterBody2D
@onready var get_player: RayCast2D = $GetPlayer
@onready var timer: Timer = $Timer


var pig_points: int = 30
var health: int = 1
var direction := -1
var last_direction = direction
var direction_changed: bool  = false

enum States {
	CHASE,
	WANDER
}

var current_state = States.WANDER


@onready var ground_checker: RayCast2D = $GroundChecker

func chase_player() -> void:
	timer.stop()
	current_state = States.CHASE

func stop_chase() -> void:
	if timer.time_left <= 0:
		timer.start()

func look_for_player()-> void:
	if get_player.is_colliding():
		var collider = get_player.get_collider()
		if collider == player:
			chase_player()
		elif current_state == States.CHASE:
			stop_chase()
	elif current_state == States.CHASE:
		stop_chase()

func move_enemy() -> void:
	var at_edge = is_at_platform_edge()

	if current_state == States.WANDER:
		sprite_2d.play("walk")
		if not at_edge:
			velocity.x = move_speed * direction
		else:
			direction *= -1
			update_direction_visuals()

	elif current_state == States.CHASE:
		sprite_2d.play("chase")
		if not at_edge:
			velocity.x = 2 * move_speed * direction
		else:
			velocity.x = 0
			await get_tree().create_timer(0.7).timeout
			stop_chase()

func reverse_direction()->void:
	if is_on_wall():
		direction = -direction
		ground_checker.position.x *= -1
		get_player.scale.x *= -1
		sprite_2d.scale.x *= -1
		last_direction = direction
		
func update_direction_visuals():
	ground_checker.position.x *= -1
	get_player.scale.x *= -1
	sprite_2d.scale.x *= -1
	last_direction = direction

func is_at_platform_edge()->bool:
	return not ground_checker.is_colliding()

func add_gravity(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
#===============================================================================
#makes sprite directions all weird
func direction_changed_timer()-> void:
	direction_changed = true
	if direction_changed:
		await get_tree().create_timer(0.3).timeout
		direction_changed = false
#===============================================================================

func _ready() -> void:
	add_to_group("enemies")
	
func _physics_process(delta: float) -> void:
	if last_direction != direction:
		ground_checker.position.x *= -1
		get_player.scale.x *= -1
		sprite_2d.scale.x *= -1
		last_direction = direction

	add_gravity(delta)
	look_for_player()
	move_enemy()
	#platform_edge()
	move_and_slide()
	reverse_direction()
	
	if current_state == States.CHASE:
		direction = (player.position.x - self.position.x)
		direction = sign(direction)
	


func _on_timer_timeout() -> void:
	current_state =  States.WANDER


func _on_area_2d_body_entered(body: Node2D) -> void:
	print("pig hitting")
	if body.name == "MainCharacter":
		var x_delta: float = body.position.x - position.x
		body.hurt_and_knockback(x_delta, game_manager, playerHurtDamage)
		
		
