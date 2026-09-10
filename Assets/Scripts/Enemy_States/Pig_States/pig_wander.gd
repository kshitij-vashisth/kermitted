extends State
@export var pig: CharacterBody2D

func physics_update(delta: float) -> void:
	if pig.can_move:
		pig.move_enemy()
	
	pig.look_for_player()
	pig.add_gravity(delta)
	pig.platform_edge()
	pig.move_and_slide()
