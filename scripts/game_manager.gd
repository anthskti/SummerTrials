extends Node

# References to both characters
@onready var sakuti = $"../Sakuti"
@onready var kitspii = $"../Kitspii"

var active_character = null
var level_start_time: float = 0.0
var level_time: float = 0.0
var level_complete: bool = false

# Collectible tracking
var collectible_obtained: bool = false
var total_collectibles: int = 0
var collected_count: int = 0

func _ready():
	# Start with Sakuti active
	set_active_character(sakuti)
	level_start_time = Time.get_ticks_msec() / 1000.0
	
	# Find and connect all collectibles in the scene
	register_collectibles()

func _process(delta):
	if not level_complete:
		level_time = (Time.get_ticks_msec() / 1000.0) - level_start_time
	
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

func _on_collectible_obtained():
	collected_count += 1
	collectible_obtained = true
	print("Collectible obtained! Total: ", collected_count, "/", total_collectibles)
	
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
	var bonus_text = " (Bonus obtained!)" if collectible_obtained else ""
	print("Level Complete! Time: ", level_time, " seconds", bonus_text)
	print("Collectibles: ", collected_count, "/", total_collectibles)
	# You can add level completion UI here later

func reset_level():
	get_tree().reload_current_scene()
