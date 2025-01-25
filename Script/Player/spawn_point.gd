extends Node3D

@export var scene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	await get_tree().process_frame
	
	var node : Node3D = scene.instantiate()
	node.position = global_position
	node.basis = global_basis
	get_parent_node_3d().add_child(node)
