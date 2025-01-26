extends Node

@export var shapes : Array[CollisionShape3D] = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	(get_parent() as Obstacle).got_hit.connect(_on_hit)
	
func _on_hit():
	for shape in shapes:
		shape.disabled = true 
