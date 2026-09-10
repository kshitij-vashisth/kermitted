extends State
@export var player: CharacterBody2D
@export var player_collider: CollisionShape2D
@export var warp_sound: AudioStreamPlayer
func enter() -> void:
	#player_collider.disabled = true
	warp_sound.play()
	player.player_sprites.play("warp_exit")
	await player.player_sprites.animation_finished
	player.hide()
	#player.queue_free()
	
func physics_update(delta: float) -> void:
	player_collider.disabled = true
