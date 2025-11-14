extends CanvasLayer

# Badge thresholds (in seconds) - adjust these per level
@export var diamond_time: float = 10.0
@export var platinum_time: float = 15.0
@export var gold_time: float = 30.0
@export var silver_time: float = 60.0

@onready var time_label = $TimerContainer/TimeLabel
@onready var badge_label = $TimerContainer/BadgeLabel
@onready var game_manager = $"../GameManager"

func _ready():
	# Make sure UI elements exist
	if not time_label:
		push_error("TimerUI: TimeLabel not found")
	if not badge_label:
		push_error("TimerUI: BadgeLabel not found")
	if not game_manager:
		push_error("TimerUI: GameManager not found")

	# Safety check - don't update if nodes don't exist
func _process(delta):
	if not time_label or not badge_label or not game_manager:
		return
	
	if game_manager:
		var current_time = game_manager.get_level_time()
		update_display(current_time)

func update_display(time: float):
	# Format time as MM:SS.MS
	var minutes = int(time) / 60
	var seconds = int(time) % 60
	var milliseconds = int((time - int(time)) * 100)
	
	time_label.text = "%02d:%02d.%02d" % [minutes, seconds, milliseconds]
	
	# Update badge prediction
	var badge = get_badge_for_time(time)
	badge_label.text = "Current: " + badge
	
	# Color code the badge
	match badge:
		"Diamond":
			badge_label.modulate = Color(0.6, 0.9, 1.0)  # Light blue
		"Platinum":
			badge_label.modulate = Color(0.5, 0.0, 0.8)  # Silver/white
		"Gold":
			badge_label.modulate = Color(1.0, 0.84, 0.0)  # Gold
		"Silver":
			badge_label.modulate = Color(0.75, 0.75, 0.75)  # Silver
		"Bronze":
			badge_label.modulate = Color(0.8, 0.5, 0.2)  # Bronze
		_:
			badge_label.modulate = Color(1, 1, 1)

func get_badge_for_time(time: float) -> String:
	if time <= diamond_time:
		return "Diamond"
	elif time <= platinum_time:
		return "Platinum"
	elif time <= gold_time:
		return "Gold"
	elif time <= silver_time:
		return "Silver"
	else:
		return "Bronze"

func show_completion_badge():
	if game_manager:
		var final_time = game_manager.get_level_time()
		var final_badge = get_badge_for_time(final_time)
		print("Level Complete! Time: ", final_time, " Badge: ", final_badge)
		# You can add a popup UI here later
