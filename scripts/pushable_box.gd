extends RigidBody2D

@export var is_heavy: bool = false  # true = only strong can push, false = anyone can push
@export var push_force: float = 300.0

func _ready():
	lock_rotation = true
	linear_damp = 12.0
	
	if is_heavy:
		mass = 20.0
	else:
		mass = 5.0
	
	# Make sure collision is always on
	collision_layer = 1
	collision_mask = 1

func _physics_process(delta):
	# Get nearby bodies
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsShapeQueryParameters2D.new()
	query.shape = $CollisionShape2D.shape
	query.transform = $CollisionShape2D.global_transform
	query.collide_with_bodies = true
	
	var results = space_state.intersect_shape(query, 10)
	
	for result in results:
		var body = result.collider
		
		# Check if it's a character
		if body != self and body.has_method("can_push_heavy_objects"):
			# Check if they're allowed to push this box
			var can_push = false
			
			if is_heavy:
				# Heavy box - only strong characters
				can_push = body.can_push_heavy_objects() and body.is_active
			else:
				# Light box - anyone
				can_push = body.is_active
			
			if can_push and abs(body.velocity.x) > 10:
				# Apply push force
				var push_dir = sign(body.velocity.x)
				apply_central_force(Vector2(push_dir * push_force, 0))
