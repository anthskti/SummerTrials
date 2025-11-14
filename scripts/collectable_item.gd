extends Area2D

# Signal to notify when collected
signal item_collected

var is_collected: bool = false

@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	# Check if either character collected it
	if not is_collected and (body.name == "Sakuti" or body.name == "Kitspii"):
		collect_item()

func collect_item():
	is_collected = true
	emit_signal("item_collected")
	
	print("Item collected!")  # Debug
	
	# Visual feedback - fade out and spin
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "modulate:a", 0.0, 0.3)
	tween.tween_property(self, "rotation", PI * 2, 0.3)
	tween.tween_property(self, "scale", Vector2(1.5, 1.5), 0.3)
	
	# Disable collision
	collision.call_deferred("set_disabled", true)
	
	# Remove after animation
	await tween.finished
	queue_free()

func reset():
	is_collected = false
	modulate.a = 1.0
	rotation = 0
	scale = Vector2(1, 1)
	if collision:
		collision.disabled = false
