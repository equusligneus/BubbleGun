class_name Impact
extends Node3D

@export var splash_scene : PackedScene
@export var rotate_scene : bool = true
@export var sound_effect : String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	(get_parent() as Bullet).hit.connect(_on_hit)

func _on_hit(collision: KinematicCollision3D):
	Audio.play(sound_effect)
	if splash_scene != null:
		var effect := splash_scene.instantiate() as Node3D
		effect.global_position = collision.get_position()
		if rotate_scene:
			effect.global_basis = to_basis(collision)
		get_parent().add_sibling(effect)

static func to_basis(collision: KinematicCollision3D) -> Basis:
	var normal := collision.get_normal()
	var abs_y = abs(normal.y)
	
	var is_horizontal := bool(abs_y >= abs(normal.x) && abs_y >= abs(normal.z))
	var right : Vector3 = normal.cross(Vector3.FORWARD if is_horizontal else Vector3.UP) 
	var fwd := right.cross(normal)
	return Basis(right, normal, fwd).orthonormalized()
