extends CanvasLayer

@onready var time_label = $Panel/TimeLabel
@onready var badge_label = $Panel/BadgeLabel
@onready var next_button = $Panel/NextButton
@onready var retry_button = $Panel/RetryButton
@onready var menu_button = $Panel/MenuButton

# Set these for each level
@export var next_level_path: String = ""  # e.g. "res://scenes/levels/level_2.tscn"
@export var current_level_path: String = ""  # e.g. "res://scenes/levels/level_1.tscn"

func _ready():
	# Hide by default
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide()
	if not time_label:
		push_error("LevelComplete: TimeLabel not found")
	if not badge_label:
		push_error("LevelComplete: BadgeLabel not found")
	if not next_button:
		push_error("LevelComplete: NextButton not found")
	

func show_completion(time: float, badge: String):
	var minutes = int(time) / 60
	var seconds = int(time) % 60
	var milliseconds = int((time - int(time)) * 100)
	
	time_label.text = "%02d:%02d.%02d Timed!" % [minutes, seconds, milliseconds]
	badge_label.text = "Badge Earned: " + badge
	
	# Color code badge
	match badge:
		"Diamond":
			badge_label.modulate = Color(0.6, 0.9, 1.0)
		"Platinum":
			badge_label.modulate = Color(0.9, 0.9, 0.9)
		"Gold":
			badge_label.modulate = Color(1.0, 0.84, 0.0)
		"Silver":
			badge_label.modulate = Color(0.75, 0.75, 0.75)
		"Bronze":
			badge_label.modulate = Color(0.8, 0.5, 0.2)
	
	# Hide next button if no next level
	if next_level_path == "":
		next_button.visible = false
	
	# Show the popup
	show()
	# Pause game
	await get_tree().create_timer(0.5).timeout
	get_tree().paused = true


func _on_retry_button_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_menu_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main_menu.tscn")


func _on_next_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file(next_level_path)
