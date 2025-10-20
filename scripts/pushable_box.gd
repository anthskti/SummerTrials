extends RigidBody2D

# Set this to true for boxes both characters can push
@export var can_be_pushed_by_nimble: bool = false
@export var push_force: float = 800.0  # Increased force

var bodies_nearby: Array = []
var being_pushed: bool = false

@onready var push_detector: Area2D = null

func _ready():
	# Set up physics properties
	gravity_scale = 1.0
	lock_rotation = true
	linear_damp = 0.5  # Very low damp
	angular_damp = 10.0
	mass = 1.0  # Very light
	continuous_cd = RigidBody2D.CCD_MODE_CAST_RAY
	
	# CRITICAL: Make sure box can move
	freeze = false
	sleeping = false
	can_sleep = false  # Prevent physics sleep
	
	# Set physics material
	var physics_mat = PhysicsMaterial.new()
	physics_mat.friction = 0.1  # Very low friction
	physics_mat.bounce = 0.0
	physics_material_override = physics_mat
	
	# Create push detector area
	setup_push_detector()

func setup_push_detector():
	# Create an Area2D to detect nearby characters
	push_detector = Area2D.new()
	add_child(push_detector)
	
	# Create collision shape for the detector (slightly larger than box)
	var detector_shape = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.size = Vector2(70, 70)  # Larger detection area
	detector_shape.shape = shape
	push_detector.add_child(detector_shape)
	
	# Set collision layers
	push_detector.collision_layer = 0
	push_detector.collision_mask = 2  # Detect players
	
	# Connect signals
	push_detector.body_entered.connect(_on_push_detector_entered)
	push_detector.body_exited.connect(_on_push_detector_exited)

func _on_push_detector_entered(body):
	if body is CharacterBody2D:
		if body not in bodies_nearby:
			bodies_nearby.append(body)

func _on_push_detector_exited(body):
	if body in bodies_nearby:
		bodies_nearby.erase(body)

func _physics_process(delta):
	being_pushed = false
	
	# Check each nearby character
	for body in bodies_nearby:
		if not is_instance_valid(body):
			continue
			
		var is_sakuti = body.name == "Sakuti"
		
		# Check if Sakuti can push this box
		if is_sakuti and not can_be_pushed_by_nimble:
			print("Sakuti TOO WEAK for this box!")
			continue
		
		# SIMPLIFIED: Just check if character is moving
		var char_velocity = body.velocity.x
		
		if abs(char_velocity) > 30:
			# Apply force in the direction the character is moving
			var push_dir = sign(char_velocity)
			apply_central_force(Vector2(push_dir * push_force, 0))
			being_pushed = true
			
			print(body.name, " PUSHING! Vel:", char_velocity, " Force:", push_dir * push_force)
			print("Box velocity:", linear_velocity.x)
	
	# Slow down when not being pushed
	if not being_pushed:
		linear_velocity.x = lerp(linear_velocity.x, 0.0, 5.0 * delta)
	
	# Visual feedback
	if being_pushed:
		modulate = Color(1.5, 1.5, 0.5)  # Bright yellow when pushed
	else:
		modulate = Color(1, 1, 1)
