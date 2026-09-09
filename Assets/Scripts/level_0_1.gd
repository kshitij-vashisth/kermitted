extends Node

@export var gun: AnimatedSprite2D
@export var player: CharacterBody2D
@export var sfx_achieved: AudioStreamPlayer
@export var dialogue_layer: CanvasLayer
@export var panel: Panel
@export var text: Label


func _ready() -> void:
	if GameManager.has_gun == false:
		player.hasGun = false
	else:
		gun.queue_free()

func panel_dialogue() -> void:
	Anima.begin_single_shot(self) \
	.then(Anima.Node(panel).anima_scale_y(1.0, 0.3).anima_from(0)) \
	.then(Anima.Node(text).anima_animation('typewrite', 0.03) ) \
	.then(Anima.Node(panel).anima_animation('fade out', 0.3) ) \
	.set_visibility_strategy(ANIMA.VISIBILITY.TRANSPARENT_ONLY) \
	.play_with_delay(0.5)




func _on_pickup_gun_area_body_entered(body: Node2D) -> void:
	if body.name == "MainCharacter":
		body.change_state("warp_in", body.state_access)
		body.hasGun = true
		GameManager.has_gun = true
		gun.queue_free()
		await body.player_sprites.animation_finished
		get_tree().paused = true
		body.velocity.x = 0
		sfx_achieved.play()
		dialogue_layer.show()
		#panel_dialogue()


func _on_button_pressed() -> void:
	dialogue_layer.hide()
	get_tree().paused = false
	dialogue_layer.queue_free()
