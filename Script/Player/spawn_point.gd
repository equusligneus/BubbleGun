extends Node3D

@export var scene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	
	var node : Node3D = scene.instantiate()
	node.position = global_position
	var new_basis := global_basis
	new_basis.x *= node.scale.x
	new_basis.y *= node.scale.y
	new_basis.z *= node.scale.z
	node.basis = new_basis
	get_parent_node_3d().add_child(node)
	get_parent().set_player(node);
