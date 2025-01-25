class_name Ground
extends RefCounted

var basis: Basis
var friction: float = 0.0
var bounciness: float = 0.0
var is_grounded: bool = false
const MIN_GROUND_NORMAL_Y := 0.7

func _init(character: CharacterBody3D):
	basis = character.transform.basis
	if !character.is_on_floor():
		return
		
	for i in character.get_slide_collision_count():
		var collision := character.get_slide_collision(i)
		var collider := collision.get_collider() as StaticBody3D
		if collider == null:
			continue
		 
		var normal := collision.get_normal()
		if normal.y < MIN_GROUND_NORMAL_Y:
			continue
		
		is_grounded = true
		
		var right := normal.cross(basis.z).normalized()
		var forward := right.cross(normal).normalized()
		basis = Basis(right, normal, forward)
		var phys_mat := collider.physics_material_override
		friction = phys_mat.friction if phys_mat != null else 1.0
		bounciness = phys_mat.bounce if phys_mat != null else 0.0
