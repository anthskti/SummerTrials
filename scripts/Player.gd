extends CharacterBody2D

# Character properties
@export var character_name: String = "BaseCharacter"
@export var is_nimble: bool = true 
@export var speed: float = 200.0
@export var jump_velocity: float = -400.0
@export var is_active: bool = true

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Visual feedback
@onready var sprite = $AnimatedSprite2D
@onready var collision = $CollisionShape2D

func _ready():
	# Set character size based on type
	if is_nimble: # sakuti
		scale = Vector2(1.0, 1.0) 
		speed = 200.0
		jump_velocity = -550.0
	else:  # kitspii
		scale = Vector2(1, 1) 
		speed = 130.0
		jump_velocity = -330.0
	
	update_visual_state()

func _physics_process(delta):
	# Only process input if this character is active
	if not is_active:
		# Apply gravity to inactive character
		if not is_on_floor():
			velocity.y += gravity * delta
		move_and_slide()
		return
	
	# Add gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Handle Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	
	# Get input direction
	var direction = Input.get_axis("move_left", "move_right")
	
	if direction != 0:
		velocity.x = direction * speed
		# Flip sprite based on direction
		sprite.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	move_and_slide()


func set_active(active: bool):
	is_active = active
	if not is_active:
		velocity.x = 0
	update_visual_state()

func update_visual_state():
	# Visual indication of active character
	if is_active:
		modulate = Color(1, 1, 1, 1) 
	else:
		modulate = Color(0.6, 0.6, 0.6, 1)  # Dimmed inactive character

func can_fit_through_small_gap() -> bool:
	return is_nimble

func can_push_heavy_objects() -> bool:
	return not is_nimble
