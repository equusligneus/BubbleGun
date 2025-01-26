extends Node

class ExplodeState:
	var _target : Node3D
	var _direction : Vector3
	var _explode_speed: float
	
	func _init(target, speed, axis):
		_target = target
		_explode_speed = speed
		_direction = axis
		
	func update(delta):
		_target.translate(_direction * _explode_speed * delta)

@export var _targets : Array[Node3D]
@export var _explode_speed_min := 10.0
@export var _explode_speed_max := 25.0

var _explode_state : Array[ExplodeState] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	(get_parent() as Obstacle).got_hit.connect(_on_hit)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for state in _explode_state:
		state.update(delta)

func _on_hit():
	for target in _targets:
		_explode_state.push_back(ExplodeState.new(target, randf_range(_explode_speed_min, _explode_speed_max), Vector3(randf() * 2.0 - 1.0, randf() * 2.0 - 1.0, randf() * 2.0 - 1.0).normalized()))
	
