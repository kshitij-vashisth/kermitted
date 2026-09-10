extends CanvasLayer
@export var game_manager: Node
@export var points_label: Label
@export var mosquito_points_label: Label
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	points_label.text = GameManager.check_zero_add_zero()
	mosquito_points_label.text = str(GameManager.num_mosquitoes)
