extends Node
@onready var pause_panel: Panel = %PausePanel

func _process(_delta: float) -> void:
	var esc_pressed: bool = Input.is_action_just_pressed("pause")
	if esc_pressed:
		get_tree().paused = true
		pause_panel.show()

func _on_resume_button_pressed() -> void:
	pause_panel.hide()
	get_tree().paused = false

func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Assets/Scenes/TransitionScreens/main_menu.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()
