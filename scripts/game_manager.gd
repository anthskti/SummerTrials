extends Node

# References to both characters
@onready var sakuti = $"../Sakuti"
@onready var kitspii = $"../Kitspii"

# Reference for level completition popup

var active_character = null
var level_start_time: float = 0.0
var level_time: float = 0.0
var level_complete: bool = false

# Collectible tracking
var collectible_obtained: bool = false
var total_collectibles: int = 0
var collected_count: int = 0
var time_bonus_total: float = 0.0 # From Collectible_item

func _ready():
	# Start with Sakuti active
	set_active_character(sakuti)
	level_start_time = Time.get_ticks_msec() / 1000.0
	
	# Find and connect all collectibles in the scene
	register_collectibles()

func _process(delta):
	if not level_complete:
		var raw_time = (Time.get_ticks_msec() / 1000.0) - level_start_time
		level_time = max(0, raw_time - time_bonus_total) 
	
	# Handle character switching
	if Input.is_action_just_pressed("swap_character"):
		swap_character()

func register_collectibles():
	# Find all nodes with group "collectible" or script "collectable_item.gd"
	var collectibles = get_tree().get_nodes_in_group("collectible")
	total_collectibles = collectibles.size()
	
	for collectible in collectibles:
		if collectible.has_signal("item_collected"):
			collectible.item_collected.connect(_on_collectible_obtained)

func _on_collectible_obtained(collectible):
	collected_count += 1
	collectible_obtained = true
	time_bonus_total += collectible.time_bonus
	print("Collectible obtained! -", collectible.time_bonus, " seconds")
	
	print("Total collected: ", collected_count, "/", total_collectibles)
	print("Total time bonus: ", time_bonus_total, " seconds")
	
	# Will add bonus later

func swap_character():
	if active_character == sakuti:
		set_active_character(kitspii)
	else:
		set_active_character(sakuti)

func set_active_character(character):
	# Deactivate previous character
	if active_character != null:
		active_character.set_active(false)
	
	# Activate new character
	active_character = character
	active_character.set_active(true)

func get_level_time() -> float:
	return level_time

func has_collectible() -> bool:
	return collectible_obtained

func get_collectible_count() -> int:
	return collected_count

func complete_level():
	level_complete = true
	print("Level Complete! Time: ", level_time, " seconds")
	
	# Get badge from TimerUI
	var timer_ui = get_tree().get_first_node_in_group("timer_ui")
	var badge = "Bronze"
	if timer_ui and timer_ui.has_method("get_badge_for_time"):
		badge = timer_ui.get_badge_for_time(level_time)
	
	# Show completion popup
	var level_complete_ui = get_tree().get_first_node_in_group("level_complete")
	if level_complete_ui.has_method("show_completion"):
		level_complete_ui.show_completion(level_time, badge)

func reset_level():
	get_tree().reload_current_scene()
