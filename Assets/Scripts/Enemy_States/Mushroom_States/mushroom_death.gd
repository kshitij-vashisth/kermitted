extends State
@export var enemy: CharacterBody2D
@export var sprite: AnimatedSprite2D
@export var death_sound: AudioStreamPlayer

func enter() -> void:
	if enemy.death_sound_choice == 0:
		death_sound.play()
	elif enemy.death_sound_choice == 1:
		enemy.squash_sound.play()
	sprite.play("death")
	GameManager.points += enemy.points
	enemy.pointsEnabled = false
	await sprite.animation_finished
	enemy.queue_free()

func physics_update(_delta: float) -> void:
	enemy.collider1.disabled = true
	enemy.collider2.disabled = true
