extends Area2D

# Track which characters have reached the finish
var sakuti_finished: bool = false
var kitspii_finished: bool = false

@onready var sprite = $Sprite2D
@onready var game_manager = $"../GameManager"
func _ready():
	# Connect the body_entered signal
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.name == "Sakuti":
		sakuti_finished = true
		print("Sakuti finished") # for testing
	elif body.name == "Kitspii":
		kitspii_finished = true
		print("Kitspii finished") # for testing
	
	check_level_complete()

func _on_body_exited(body):
	# If a character leaves the finish area, mark them as not finished
	if body.name == "Sakuti":
		sakuti_finished = false
	elif body.name == "Kitspii":
		kitspii_finished = false

func check_level_complete():
	# Both characters must be at the finish line
	if sakuti_finished and kitspii_finished:
		game_manager.complete_level()
		# Visual feedback
		sprite.modulate = Color(0, 1, 0, 1)  # Turn green when complete
