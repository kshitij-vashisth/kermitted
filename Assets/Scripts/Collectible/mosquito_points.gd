extends CharacterBody2D

@export var direction = -1
@export var SPEED = 300.0

@export var turn_timer = 0.0
@export var TURN_INTERVAL = 1.9
@export var caught: bool = false
@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D
@export var state_access: StateMachine 
@export var move_sound: AudioStreamPlayer2D
@export var eaten_sound: AudioStreamPlayer2D

func change_state(desired_state_name: String, state_machine):
		#var current_state_name = str(state_access.current_state)
		state_machine.change_state(desired_state_name)
func move_enemy() -> void:
	#move_sound.play()
	velocity.x = SPEED * direction

func turn_around(delta: float) -> void:
	turn_timer += delta
	if turn_timer >= TURN_INTERVAL:
		turn_timer = 0.0
		direction = -direction
		animated_sprite_2d.scale.x *= -1

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "MainCharacter":
		GameManager.mosquito_add_points()
		caught = true
		change_state("eaten",state_access)
