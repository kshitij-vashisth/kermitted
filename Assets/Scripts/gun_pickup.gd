extends AnimatedSprite2D


@export var player: CharacterBody2D

func _ready() -> void:
	player.hasGun = false

func _on_pickup_gun_area_body_entered(body: Node2D) -> void:
	print("pickup working")

	if body.name == "MainCharacter":
		print("player picked up")

		body.change_state("warp_in", body.state_access)

		body.hasGun = true
		print(body.hasGun)
