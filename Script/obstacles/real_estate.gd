class_name RealEstate
extends Obstacle

var _destroyed := false
@export var _demolition_duration := 1.5

func destroy():
	if _destroyed: return
	_destroyed = true
	got_hit.emit()
	var tween := create_tween()
	tween.tween_interval(_demolition_duration)
	tween.tween_callback(func(): queue_free())
