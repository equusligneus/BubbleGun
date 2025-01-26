class_name Gun
extends Node

var raycast: RayCast3D
var blaster_cooldown: Timer

@export var _cooldown := 0.1
@export var _bullet_spawn_point : Node3D
@export var _ammo_display : Sprite3D
@export var _ammo_count : Label3D

var _gunner: Gunner
var _inventory : Inventory
var _ammo : AmmoInstance

# Called when the node enters the scene tree for the first time.
func init() -> void:
	_gunner = get_parent() as Gunner
	raycast = _gunner.raycast
	blaster_cooldown = _gunner.blaster_cooldown
	_inventory = _gunner.get_inventory()
	_inventory.ammo_selection_changed.connect(_on_ammo_selection_changed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if _gunner.get_menu().is_open(): return
	
	if !Input.is_action_just_pressed("shoot"): return
	
	if !blaster_cooldown.is_stopped(): return # Cooldown for shooting
	
	var ammo := _inventory.get_current()
	if ammo == null || ammo.is_empty(): return
	
	blaster_cooldown.start(_cooldown)
	
	if _bullet_spawn_point == null: return
	
	var position := _bullet_spawn_point.global_position
	var direction := _bullet_spawn_point.global_basis.z
	
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

func _on_ammo_selection_changed(_index: int):
	if _ammo != null:
		_ammo.ammo_count_changed.disconnect(_on_ammo_count_changed)
		_ammo_display.texture = null
	
	_ammo = _inventory.get_current()
	if _ammo != null:
		_ammo.ammo_count_changed.connect(_on_ammo_count_changed)
		_ammo_display.texture = _ammo.get_type().get_icon()
		_on_ammo_count_changed(_ammo.get_amount())
	
	_ammo_display.visible = _ammo != null

func _on_ammo_count_changed(amount: int):
	_ammo_count.text = str(amount)
