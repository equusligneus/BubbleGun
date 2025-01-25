extends Node

@export var _duration := 5.0

func _on_hit(collision: KinematicCollision3D) -> void:
	if collision.get_collider() is Machinery:
		(collision.get_collider() as Machinery).gum_up(_duration)
