extends Node

# References to both characters
@onready var sakuti = $"../Sakuti"
@onready var kitspii = $"../Kitspii"

var active_character = null
var level_start_time: float = 0.0
var level_time: float = 0.0
var level_complete: bool = false

func _ready():
	# Start with Sakuti active
	set_active_character(sakuti)
	level_start_time = Time.get_ticks_msec() / 1000.0

func _process(delta):
	if not level_complete:
		level_time = (Time.get_ticks_msec() / 1000.0) - level_start_time
	
	# Handle character switching
	if Input.is_action_just_pressed("swap_character"):
		swap_character()

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

func complete_level():
	level_complete = true
	print("Level Complete! Time: ", level_time, " seconds")
	# You can add level completion UI here later

func reset_level():
	get_tree().reload_current_scene()
