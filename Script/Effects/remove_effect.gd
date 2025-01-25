extends Node3D

@export var duration : float = 5.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(duration).timeout
	queue_free()
