class_name IngameMenu
extends Control

func set_player(player: Gunner):
	player.add_child(self)
	_set_visible(false)

func is_open() -> bool:
	return visible

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	## Mouse capture
	if Input.is_action_just_pressed("mouse_capture_toggle"):
		_set_visible(!visible)

func _set_visible(is_visible: bool):
	visible = is_visible
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if !visible else Input.MOUSE_MODE_VISIBLE
	
func _on_continue_pressed() -> void:
	_set_visible(false)

func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()

func _on_quit_pressed() -> void:
	get_tree().quit()
