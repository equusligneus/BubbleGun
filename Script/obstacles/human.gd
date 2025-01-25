class_name Human
extends Node3D

var _tween : Tween
var _axis : Vector3
@onready var human : Node3D = $root 

func _process(delta: float) -> void:
	if !is_instance_valid(_tween): return
	
	human.rotate(_axis, 20.0 * delta)

func die():
	if is_instance_valid(_tween): return
	
	_axis = Vector3(randf() * 2.0 - 1.0, randf() * 2.0 - 1.0, randf() * 2.0 - 1.0).normalized()
	_tween = create_tween()
	_tween.tween_property(self, "scale", Vector3.ZERO, 0.75).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	_tween.tween_callback(func(): queue_free())
