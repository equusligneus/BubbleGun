class_name Gun
extends Node

var raycast: RayCast3D
var muzzle: AnimatedSprite3D
var container: Node3D
var blaster_cooldown: Timer

@export var crosshair:TextureRect

var _inventory : Inventory

# Called when the node enters the scene tree for the first time.
func init() -> void:
	var node = get_parent()
	raycast = node.raycast
	muzzle = node.muzzle
	container = node.container
	blaster_cooldown = node.blaster_cooldown


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	if !Input.is_action_pressed("shoot"): return
	
	if !blaster_cooldown.is_stopped(): return # Cooldown for shooting
	
	#Audio.play(weapon.sound_shoot)
	
	container.position.z += 0.25 # Knockback of weapon visual
	#camera.rotation.x += 0.025 # Knockback of camera
	#movement_velocity += Vector3(0, 0, weapon.knockback) # Knockback
	
	# Set muzzle flash position, play animation
	
	muzzle.play("default")
	
	muzzle.rotation_degrees.z = randf_range(-45, 45)
	muzzle.scale = Vector3.ONE * randf_range(0.40, 0.75)
	#muzzle.position = container.position - weapon.muzzle_position
	
	#blaster_cooldown.start(weapon.cooldown)
	
	# Shoot the weapon, amount based on shot count
	
	#for n in weapon.shot_count:
	#
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
