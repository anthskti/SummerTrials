extends Control

func _on_level_1_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/level_1.tscn")

func _on_level_2_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/level_2.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()
