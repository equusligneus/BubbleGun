class_name RealEstate
extends Node3D

var _tween : Tween
@onready var houses : Node3D = $root 

func destroy():
	if is_instance_valid(_tween): return
	
	_tween = create_tween()
	_tween.tween_property(houses, "position", Vector3.DOWN * 2, 0.75).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	_tween.tween_callback(func(): queue_free())
