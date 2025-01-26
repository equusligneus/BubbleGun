class_name Gunner
extends CharacterBody3D

@export_subgroup("Movement")
@export var _movement_speed := 5.0
@export var _acceleration := 50.0
@export var _jump_strength := 20.0
@export var _gravity := -20.0
@export var _bounce_threshold := -5.0

@export var _air_control := 0.2

@export var _turn_rate := 30.0

@onready var _ground := Ground.new(self)
@onready var _upwards := Vector3(0.0, _gravity, 0.0)
var _ground_movement := Vector3()

@export_subgroup("UI")
@export var hud_scene : PackedScene
@export var menu_scene: PackedScene

var mouse_sensitivity = 700
var gamepad_sensitivity := 0.075

var _rotation_input := Vector2()


var hud: HUD;

@onready var head : Node3D = $Head
@onready var camera : Camera3D = $Head/Camera
@onready var raycast : RayCast3D = $Head/Camera/RayCast
@onready var muzzle : AnimatedSprite3D = $Head/Camera/SubViewportContainer/SubViewport/CameraItem/Muzzle
@onready var container : Node3D = $Head/Camera/SubViewportContainer/SubViewport/CameraItem/Container
@onready var sound_footsteps : AudioStreamPlayer = $SoundFootsteps
@onready var blaster_cooldown : Timer = $Cooldown
@onready var _inventory := Inventory.new(self)
@onready var _gun : Gun = $Gun

var _menu : IngameMenu

# Functions
func get_inventory() -> Inventory:
	return _inventory

func get_menu() -> IngameMenu:
	return _menu

func _ready():
	_gun.init()
	hud = hud_scene.instantiate()
	hud.set_player(self)
	
	_menu = menu_scene.instantiate()
	_menu.set_player(self)

func _physics_process(delta):
	if _menu.is_open(): return
	
	# Handle functions	
	_handle_controls()
	_handle_gravity(delta)
	_handle_rotation(delta)
	_handle_movement(delta)
	
	# Falling/respawning
	if position.y < -10:
		get_tree().reload_current_scene()

# Mouse movement

func _input(event):
	if event is InputEventMouseMotion and !_menu.is_open():
		_rotation_input -= event.relative / mouse_sensitivity

func _handle_controls():
	## Rotation
	_rotation_input += Input.get_vector("camera_right", "camera_left", "camera_down", "camera_up") * gamepad_sensitivity

# Handle gravity

func _handle_gravity(delta: float):
	_upwards.y = clamp(_upwards.y + _gravity * delta, _gravity, -2 * _gravity)
	
	if !Input.is_action_just_pressed("jump"): return
	if !_ground.is_grounded: return
	
	Audio.play("Kenney/sounds/jump_a.ogg, Kenney/sounds/jump_b.ogg, Kenney/sounds/jump_c.ogg")
	_upwards.y = _jump_strength

func _handle_rotation(delta: float):
	var turn := _turn_rate * delta
	rotate_y(_rotation_input.x * turn)
	head.rotate_object_local(Vector3.RIGHT, _rotation_input.y * turn)	
	head.rotation_degrees.x = clamp(head.rotation_degrees.x, -75.0, 75.0)
	
	_rotation_input = Vector2()

func _handle_movement(delta: float):
	_calc_ground_movement(delta)
	
	var was_on_ground := _ground.is_grounded
	
	_ground.reset(basis)
	
	var travel := _ground_movement
	if !_ground.is_grounded || _upwards.y > 0.0:
		travel += _upwards
	
	travel *= delta
	
	for i in 5:
		var collision := move_and_collide(travel)
		if !is_instance_valid(collision):
			break
		
		var normal := collision.get_normal()
		var reflect_factor := 1.0
		
		if _ground.is_valid_ground(collision):
			_ground.reset(basis, collision)
			if !was_on_ground && _upwards.y < _bounce_threshold:
				reflect_factor += _ground.bounciness
		else:
			# push away from wall
			var horizontal_push := Vector3(normal.x, 0, normal.y).normalized()
			travel += horizontal_push * 0.1
			_ground_movement += horizontal_push
			# null upwards movement
			_upwards.y = 0.0
		
		travel -= collision.get_travel()
		
		travel += normal * normal.dot(-travel) * reflect_factor
		_ground_movement += normal * normal.dot(-_ground_movement) * reflect_factor
		_upwards.y += normal.dot(-_upwards) * reflect_factor
	
	if _upwards.y > 0.05:
		_ground.reset(basis)

func _calc_ground_movement(delta: float):
	var control := pow(_ground.friction, 2.0) if _ground.is_grounded else _air_control
	
	## apply braking
	var accel_input := _project_on_ground(-_ground_movement) * control
	
	## apply accelerating
	var input := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	if input.length_squared() > 1.0:
		input = input.normalized()
	input *= maxf(control, _air_control)
	accel_input.x += input.x * _movement_speed
	accel_input.z += input.y * _movement_speed
	
	accel_input *= _acceleration
	
	## apply gravity slide
	if _upwards.y < 0.0:
		var slide := _project_on_ground(_upwards) * pow((1.0 - _ground.friction), 2)
		accel_input += slide
	
	_ground_movement += transform.basis * accel_input * delta

func _project_on_ground(vector: Vector3) -> Vector3:
	return Vector3(_ground.basis.x.dot(vector), _ground.basis.y.dot(vector), _ground.basis.z.dot(vector))
