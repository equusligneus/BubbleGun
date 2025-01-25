class_name Ground
extends RefCounted

var basis: Basis
var friction: float = 1.0
var bounciness: float = 0.0
var is_grounded: bool = false
var collider : StaticBody3D = null
var _max_angle: float

func _init(character: CharacterBody3D):
	basis = character.transform.basis.orthonormalized()
	_max_angle = character.floor_max_angle

func is_valid_ground(collision: KinematicCollision3D) -> bool:
	return collision.get_collider() is StaticBody3D && collision.get_angle() < _max_angle

func reset(basis: Basis, collision: KinematicCollision3D = null):
	self.basis = basis.orthonormalized()
	is_grounded = is_instance_valid(collision)
	if !is_grounded: return
	
	collider = collision.get_collider() as StaticBody3D
	var normal := collision.get_normal()
	
	var right := normal.cross(basis.z).normalized()
	var forward := right.cross(normal).normalized()
	basis = Basis(right, normal, forward)
	var phys_mat := collider.physics_material_override
	friction = phys_mat.friction if phys_mat != null else 1.0
	bounciness = phys_mat.bounce if phys_mat != null else 0.0
