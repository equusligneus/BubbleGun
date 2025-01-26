class_name Machinery
extends Obstacle

func gum_up(duration: float):
	if !_is_on(): return
	
	got_hit.emit()
	process_mode = ProcessMode.PROCESS_MODE_DISABLED
	await get_tree().create_timer(duration).timeout
	process_mode = ProcessMode.PROCESS_MODE_INHERIT

func _is_on() -> bool:
	return process_mode == ProcessMode.PROCESS_MODE_INHERIT
