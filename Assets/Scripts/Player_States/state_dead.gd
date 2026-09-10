extends State

@export var player: CharacterBody2D

func player_collider_off() -> void:
	player.get_node("MainCollider").disabled = true

func enter() -> void:
	call_deferred("player_collider_off")
	player.sfx_defeat.play()
	player.player_sprites.play("destroyed")
	await get_tree().create_timer(1.25).timeout
	player.hide()
	GameManager.decrease_lives()
