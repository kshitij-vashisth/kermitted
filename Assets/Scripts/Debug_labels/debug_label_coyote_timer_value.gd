extends RichTextLabel
@export var Player: CharacterBody2D
#@onready var timer_import: Timer = $"/root/Node/MainCharacter/$Timer_Nodes/coyote_time"
#@export var timer_import : Timer
var coyote_time_value: RichTextLabel = self
func enter() -> void:
	#if (not Player.is_on_floor()) and (not Player.is_on_wall()):
		#coyote_time_value.text = "Coyote Value: %.2f" % abs(timer_import.wait_time)
		pass

	
func _physics_process(_gdelta: float) -> void:
	
	#print(velocity_checker.text)
	pass
