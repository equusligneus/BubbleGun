extends Node

@export var _target : Node3D
@export var _tumble_speed := 20.0

var _is_tumbling := false
var _tumble_axis : Vector3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	(get_parent() as Obstacle).got_hit.connect(_on_hit)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !_is_tumbling: return
	_target.rotate(_tumble_axis, _tumble_speed * delta)

func _on_hit():
	_is_tumbling = true
	_tumble_axis = Vector3(randf() * 2.0 - 1.0, randf() * 2.0 - 1.0, randf() * 2.0 - 1.0).normalized()
	
