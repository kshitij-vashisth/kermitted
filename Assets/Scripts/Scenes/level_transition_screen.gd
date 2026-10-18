extends Node2D
@export var level_label: Label
@export var game_manager: Node
@export var lives_label: Label

func load_level(level_name: String) -> void:
	var path = "res://Assets/Scenes/Levels/%s.tscn" % level_name
	get_tree().change_scene_to_file(path)

func _ready() -> void:
	lives_label.text = "X " + str(GameManager.lives)
	level_label.text = str(GameManager.level_list[GameManager.level_index])

	var label_index = GameManager.level_list.find(level_label.text)

	if GameManager.level_index < label_index:
		GameManager.level_index = label_index

	await get_tree().create_timer(3).timeout
	load_level(GameManager.level_changer_list[GameManager.level_index])
