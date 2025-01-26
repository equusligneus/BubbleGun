class_name IngameMenu
extends Control

@onready var score = $Panel/Label2;

@onready var player: Gunner;

func set_player(player: Gunner):
	player.add_child(self)
	_set_visible(false)

func is_open() -> bool:
	return visible


func _set_visible(is_visible: bool):
	visible = is_visible
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if !visible else Input.MOUSE_MODE_VISIBLE


func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()

func _on_quit_pressed() -> void:
	get_tree().quit()
