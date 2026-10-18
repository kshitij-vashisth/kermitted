extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var current_level_index = GameManager.level_changer_list.find(
	get_tree().current_scene.scene_file_path.get_file().get_basename()
)
	print(get_tree().current_scene.scene_file_path.get_file().get_basename())
	print("current level index is:", current_level_index)
	
	if current_level_index != -1 and GameManager.level_index < current_level_index:
		GameManager.level_index = current_level_index
