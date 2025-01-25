class_name Bullet
extends CharacterBody3D

signal hit(collision: KinematicCollision3D)

@export var speed := 5.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var collision := move_and_collide(transform.basis * Vector3.FORWARD * speed)
	if is_instance_valid(collision):
		hit.emit(collision)
		queue_free()
