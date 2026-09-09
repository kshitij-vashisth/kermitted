extends RichTextLabel
@export var Player: CharacterBody2D
#@export var on_floor_checker_label: RichTextLabel
var on_floor_checker_label: RichTextLabel = self

# Called when the node enters the scene tree for the first time.
func _physics_process(_delta: float) -> void:
	#if Player.is_on_floor():
		#on_floor_checker_label.text = "On Floor: Yes"
		##print("player: on floor")
	#else:
		#on_floor_checker_label.text = "On Floor: No"
		##print("player: not on floor")
		pass
