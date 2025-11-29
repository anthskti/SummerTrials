extends CanvasLayer

@onready var sakuti_button = $VBoxContainer/SakutiButton
@onready var kitspii_button = $VBoxContainer/KitspiiButton
@onready var game_manager = $"../GameManager"

func _ready():
	# Connect buttons
	if sakuti_button:
		sakuti_button.pressed.connect(_on_sakuti_pressed)
	if kitspii_button:
		kitspii_button.pressed.connect(_on_kitspii_pressed)
	
	# Update button states initially
	update_button_states()

func _process(_delta):
	# Update button states each frame to show active character
	update_button_states()

func _on_sakuti_pressed():
	if game_manager:
		# Find Sakuti and make them active
		for child in game_manager.get_parent().get_children():
			if child.name.to_lower().contains("sakuti"):
				game_manager.set_active_character(child)
				break

func _on_kitspii_pressed():
	if game_manager:
		# Find Kitspii and make them active
		for child in game_manager.get_parent().get_children():
			if child.name.to_lower().contains("kitspii"):
				game_manager.set_active_character(child)
				break

func update_button_states():
	if not game_manager or not game_manager.active_character:
		return
	
	var active_name = game_manager.active_character.name.to_lower()
	
	# Highlight active character button
	if sakuti_button:
		if "sakuti" in active_name:
			sakuti_button.modulate = Color(1, 1, 1, 1)  # Bright
		else:
			sakuti_button.modulate = Color(0.6, 0.6, 0.6, 1)  # Dimmed
	
	if kitspii_button:
		if "kitspii" in active_name:
			kitspii_button.modulate = Color(1, 1, 1, 1)  # Bright
		else:
			kitspii_button.modulate = Color(0.6, 0.6, 0.6, 1)  # Dimmed
