extends Node

class TumbleState:
	var _target : Node3D
	var _axis : Vector3
	
	func _init(target, axis):
		_target = target
		_axis = axis
		
	func update(delta):
		_target.rotate(_axis, delta)

@export var _targets : Array[Node3D]
@export var _tumble_speed := 20.0

var _tumble_state : Array[TumbleState] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	(get_parent() as Obstacle).got_hit.connect(_on_hit)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for state in _tumble_state:
		state.update(_tumble_speed * delta)

func _on_hit():
	for target in _targets:
		_tumble_state.push_back(TumbleState.new(target, Vector3(randf() * 2.0 - 1.0, randf() * 2.0 - 1.0, randf() * 2.0 - 1.0).normalized()))
	
