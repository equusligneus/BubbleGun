extends Node

const MIN_FLOOR_Y := 0.7

@export var _effect : PackedScene

func _on_hit(collision: KinematicCollision3D):
	var normal := collision.get_normal()
	if normal.y > MIN_FLOOR_Y:
		var effect := _effect.instantiate() as Node3D
		effect.global_position = collision.get_position()
		var tan1 := normal.cross(Vector3.FORWARD)
		var tan2 := tan1.cross(normal)
		effect.transform.basis = Impact.to_basis(collision)
		get_tree().current_scene.add_child(effect)
