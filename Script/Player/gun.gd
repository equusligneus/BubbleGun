class_name Gun
extends Node

var raycast: RayCast3D
var muzzle: AnimatedSprite3D
var container: Node3D
var blaster_cooldown: Timer

@export var crosshair:TextureRect
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
	
	if !Input.is_action_pressed("shoot"): return
	
	if !blaster_cooldown.is_stopped(): return # Cooldown for shooting
	
	var ammo := _inventory.get_current()
	if ammo == null || ammo.is_empty(): return
	
	#Audio.play(weapon.sound_shoot)
	
	# Set muzzle flash position, play animation
	
	#muzzle.play("default")
	#
	#muzzle.rotation_degrees.z = randf_range(-45, 45)
	#muzzle.scale = Vector3.ONE * randf_range(0.40, 0.75)
	#muzzle.position = container.position - weapon.muzzle_position
	
	blaster_cooldown.start(_cooldown)
	
	if bullet_spawn_point == null: return
	
	var position := bullet_spawn_point.global_position
	var direction := bullet_spawn_point.global_basis.z
	
	print("Position: %f, %f, %f" % [position.x, position.y, position.z])
	print("Direction: %f, %f, %f" % [direction.x, direction.y, direction.z])
	
	raycast.force_raycast_update()
	if raycast.is_colliding():
		direction = (raycast.get_collision_point() - position).normalized()
	
	var bullet := ammo.spawn_bullet()
	get_tree().current_scene.add_child(bullet)
	bullet.global_position = position
	bullet.global_basis = Basis(Quaternion(Vector3.FORWARD, direction))
	
	if ammo.get_amount() == 0:
		_inventory.select_next()
	
	# Shoot the weapon, amount based on shot count
	
	#for n in weapon.shot_count:
	
		#raycast.target_position.x = randf_range(-weapon.spread, weapon.spread)
		#raycast.target_position.y = randf_range(-weapon.spread, weapon.spread)
		#
		#raycast.force_raycast_update()
		#
		#if !raycast.is_colliding(): continue # Don't create impact when raycast didn't hit
		#
		#var collider = raycast.get_collider()
		#
		## Hitting an enemy
		#
		#if collider.has_method("damage"):
			#collider.damage(weapon.damage)
		#
		## Creating an impact animation
		#
		#var impact = preload("res://Kenney/objects/impact.tscn")
		#var impact_instance = impact.instantiate()
		#
		#impact_instance.play("shot")
		#
		#get_tree().root.add_child(impact_instance)
		#
		#impact_instance.position = raycast.get_collision_point() + (raycast.get_collision_normal() / 10)
		#impact_instance.look_at(camera.global_transform.origin, Vector3.UP, true) 
	pass
