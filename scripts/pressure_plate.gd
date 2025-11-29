extends Area2D

# Link this to a door in the Inspector
@export var connected_door: NodePath

@export var unpressed_sprite: Texture2D  # Assign in Inspector
@export var pressed_sprite: Texture2D    # Assign in Inspector

var is_pressed: bool = false
var bodies_on_plate: int = 0

@onready var sprite = $Sprite2D
@onready var door = get_node(connected_door) if connected_door else null

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	# Accept characters or pushable boxes
	if body is CharacterBody2D or body is RigidBody2D:
		bodies_on_plate += 1
		update_plate_state()

func _on_body_exited(body):
	if body is CharacterBody2D or body is RigidBody2D:
		bodies_on_plate -= 1
		update_plate_state()

func update_plate_state():
	var was_pressed = is_pressed
	is_pressed = bodies_on_plate > 0
	
	# Visual feedback
	if is_pressed:
		sprite.texture = pressed_sprite
	else:
		sprite.texture = unpressed_sprite
	
	# Notify door if state changed
	if door and was_pressed != is_pressed:
		if is_pressed:
			door.open()
		else:
			door.close()
