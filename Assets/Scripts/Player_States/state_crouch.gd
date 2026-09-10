extends State

@export var player: CharacterBody2D

func enter()-> void:
	if player.hasGun:
		player.player_sprites.play("crouch")
	elif not player.hasGun:
		player.player_sprites.play("crouch_no_gun")
	player.velocity.x = 0


func physics_update(delta: float) -> void:
	player.apply_gravity(delta)
	
	if Input.is_action_just_released("down"):
		player.change_state("idle",player.state_access)
	
	if Input.is_action_pressed("down") and Input.is_action_just_pressed("up"):
		player.position.y += 1
	
	player.move_and_slide()
