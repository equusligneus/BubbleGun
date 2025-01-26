extends Node3D

@export var up: bool = false
var time: float = 0.0

@export var max_height: Vector3 = Vector3(0, 2.0, 0.5)
@export var min_height: Vector3 = Vector3(0, 0, 0.5)
@export var speed: float = 1.0 

func _process(delta: float) -> void:
	
	if up:
		time += delta * speed
	else:
		time -= delta * speed
		
	time = clamp(time, 0.0, 1.0)
	
	position = min_height.lerp(max_height, time)
	
	if time >= 1.0:
		up = false
	elif time <= 0.0:
		up = true
