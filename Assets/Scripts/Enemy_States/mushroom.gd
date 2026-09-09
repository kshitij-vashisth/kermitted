extends CharacterBody2D
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
@export var points: int = 150
@onready var game_manager: Node = %GameManager
@export var health: int = 1
@export var isInvincible: bool = false
@export var playerHurtDamage: int = 1
var dying: bool = false
var direction: int = -1

func change_state(desired_state_name: String, state_machine):
		var current_state_name = str(state_access.current_state)
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
	sprite.animation = "run"
	
func platform_edge()->void:
	if not ground_check.is_colliding():
		direction = -direction
		ground_check.position.x *= -1
		sprite.scale.x *= -1

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "MainCharacter":
		var y_delta: float = position.y - body.position.y
		var x_delta: float = body.position.x - position.x
		if y_delta > 30 and pointsEnabled and not isInvincible:
			can_move = false
			dying = true
			#body.velocity.y += -player_bounce_velocity
			#body.jump_count = 1
			#GameManager.points += points
			pointsEnabled = false
			body.toBounce = true
			squash()
			if not pointsEnabled:
				await get_tree().create_timer(0.2).timeout
			enemy_dead()
			queue_free()
		
		if abs(x_delta) > 0 and not dying:
			body.hurt_and_knockback(x_delta, game_manager, playerHurtDamage)
			#game_manager.decrease_health()
			#GameManager.num_hearts = game_manager.num_hearts
