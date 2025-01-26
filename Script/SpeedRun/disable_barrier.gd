extends Area3D

@export var _shape : CollisionShape3D
@export var _barriers : Array[CollisionShape3D] = []

@export var _reenable_after := -1.0

func _on_body_entered(body: Node3D):
	if body is Gunner:
		_shape.disabled = true
		for barrier in _barriers:
			barrier.disabled = true
			barrier.get_parent_node_3d().visible = false
		if _reenable_after > 0.0:
			await get_tree().create_timer(_reenable_after).timeout
			_reenable()

func _reenable():
	_shape.disabled = false
	for barrier in _barriers:
		barrier.disabled = false
		barrier.get_parent_node_3d().visible = true
