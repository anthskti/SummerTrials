extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()  
	process_mode = Node.PROCESS_MODE_ALWAYS 

func _input(event):
	if event.is_action_pressed("escape"):
		toggle_pause()

func toggle_pause():
	visible = !visible
	get_tree().paused = visible

func _on_retry_button_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_menu_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main_menu.tscn")
