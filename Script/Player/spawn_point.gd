extends Node3D

@export var scene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var node : Node3D = scene.instantiate()
	node.position = global_position
	node.basis = global_basis
	get_tree().current_scene.add_child(node)
