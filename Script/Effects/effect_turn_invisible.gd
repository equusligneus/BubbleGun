extends Node

@export var _targets : Array[Node3D] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	(get_parent() as Obstacle).got_hit.connect(_on_hit)

func _on_hit():
	for target in _targets:
		target.visible = false
