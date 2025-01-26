class_name DisableBarrier
extends Area3D

@export var _shape : CollisionShape3D
@export var _barriers : Array[CollisionShape3D] = []

@export var _temp_worker : DisableBarrier
@export var _reenable_after := -1.0

var _tween : Tween

func _on_body_entered(body: Node3D):
	if body is Gunner:
		_shape.disabled = true
		for barrier in _barriers:
			barrier.disabled = true
			barrier.get_parent_node_3d().visible = false
		if _reenable_after > 0.0:
			_tween = create_tween()
			_tween.tween_interval(_reenable_after)
			_tween.tween_callback(_reenable)
		elif _temp_worker != null:
			_temp_worker._tween.kill()

func _reenable():
	_shape.disabled = false
	for barrier in _barriers:
		barrier.disabled = false
		barrier.get_parent_node_3d().visible = true
