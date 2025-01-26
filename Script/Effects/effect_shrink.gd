extends Node

@export var _target : Node3D
@export var _shrink_duration := 0.75

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	(get_parent() as Obstacle).got_hit.connect(_on_hit)

func _on_hit():
	var tween:= create_tween()
	tween.tween_property(_target, "scale", Vector3.ZERO, _shrink_duration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	
