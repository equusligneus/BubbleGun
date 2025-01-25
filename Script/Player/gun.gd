class_name Gun
extends Node

var raycast: RayCast3D
var muzzle: AnimatedSprite3D
var container: Node3D
var blaster_cooldown: Timer

@export var _cooldown := 0.1
@export var bullet_spawn_point : Node3D


var _inventory : Inventory

# Called when the node enters the scene tree for the first time.
func init() -> void:
	var node := get_parent() as Gunner
	raycast = node.raycast
	muzzle = node.muzzle
	container = node.container
	blaster_cooldown = node.blaster_cooldown
	_inventory = node.get_inventory()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	if !Input.is_action_just_pressed("shoot"): return
	
	if !blaster_cooldown.is_stopped(): return # Cooldown for shooting
	
	var ammo := _inventory.get_current()
	if ammo == null || ammo.is_empty(): return
	
	blaster_cooldown.start(_cooldown)
	
	if bullet_spawn_point == null: return
	
	var position := bullet_spawn_point.global_position
	var direction := bullet_spawn_point.global_basis.z
	
	raycast.force_raycast_update()
	if raycast.is_colliding():
		direction = (raycast.get_collision_point() - position).normalized()
	
	var bullet := ammo.spawn_bullet()
	get_tree().current_scene.add_child(bullet)
	bullet.global_position = position
	bullet.transform.basis = create_basis(direction)
	
	if ammo.get_amount() == 0:
		_inventory.select_next()
	
func create_basis(forward: Vector3) -> Basis:
	var right := Vector3.UP.cross(forward).normalized()
	var up := forward.cross(right).normalized()
	return Basis(-right, -up, -forward)
