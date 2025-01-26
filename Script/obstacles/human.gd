class_name Human
extends Obstacle

var _destroyed := false
@export var _dying_swan_duration := 0.75

func die():
	if _destroyed: return
	_destroyed = true
	got_hit.emit()
	var tween := create_tween()
	tween.tween_interval(_dying_swan_duration)
	tween.tween_callback(func(): queue_free())
