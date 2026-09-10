extends State
@export var chase_speed_multiplier: int = 2
@export var enemy: CharacterBody2D

func enter() -> void:
	enemy.sprite.play("chase")

func physics_update(delta: float) -> void:
	enemy.add_gravity(delta)
	enemy.chase_player()
	#enemy.platform_edge()
	enemy.move_and_slide()
	enemy.player_left()
