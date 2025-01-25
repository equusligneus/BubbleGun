extends Node

func _on_hit(collision: KinematicCollision3D) -> void:
	if collision.get_collider() is RealEstate:
		(collision.get_collider() as RealEstate).destroy()
