extends StaticBody2D

@export var open_speed: float = 650.0
@export var open_distance: float = 250.0
@export var slide_direction: Vector2 = Vector2(0, -1)  # Up by default

#var is_open: bool = false
var target_position: Vector2
var start_position: Vector2

var moving_up : bool = true
var pause_timer : float = 0.0


@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D

func _ready():
	start_position = position
	target_position = start_position + (slide_direction.normalized() * open_distance)

func _process(delta):
	if pause_timer > 0:
		pause_timer -= delta
		return
		
	var goal = target_position
	if moving_up:
		goal = target_position
	else: 
		goal = start_position
	position = position.move_toward(goal, open_speed * delta)

	# If close enough to the goal, switch direction
	if position.distance_to(goal) < 1.0:
		position = goal
		moving_up = !moving_up
		#pause_timer = pause_time
