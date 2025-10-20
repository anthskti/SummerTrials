extends StaticBody2D

@export var open_speed: float = 650.0
@export var open_distance: float = 250.0
@export var slide_direction: Vector2 = Vector2(0, -1)  # Up by default

var is_open: bool = false
var target_position: Vector2
var start_position: Vector2
var open_requests: int = 0  # Track how many plates want the door open

@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D

func _ready():
	start_position = position
	target_position = start_position + (slide_direction.normalized() * open_distance)

func _process(delta):
	# Door is open if ANY plate requests it
	is_open = open_requests > 0
	
	# Smoothly move door to target position
	if is_open:
		position = position.move_toward(target_position, open_speed * delta)
		sprite.modulate = Color(0.5, 1, 0.5, 0.7)  # Green and semi-transparent
	else:
		position = position.move_toward(start_position, open_speed * delta)
		sprite.modulate = Color(1, 0.5, 0.5, 1)  # Red and solid
	
	# Disable collision when fully open
	# collision.disabled = is_open and position.distance_to(target_position) < 1

func open():
	open_requests += 1

func close():
	open_requests -= 1
	if open_requests < 0:
		open_requests = 0  # Safety check
