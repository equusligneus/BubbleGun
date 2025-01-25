class_name Gunner
extends CharacterBody3D

@export_subgroup("Movement")
@export var _movement_speed := 5.0
@export var _acceleration := 50.0
@export var _jump_strength := 20.0
@export var _gravity := -20.0
@export var _bounce_threshold := -5.0

@export var _turn_rate := 30.0

@onready var _ground := Ground.new(self)
@onready var _upwards := Vector3(0.0, _gravity, 0.0)
var _ground_movement := Vector3()

@export var hud_scene : PackedScene

var mouse_sensitivity = 700
var gamepad_sensitivity := 0.075

var mouse_captured := true

var _rotation_input := Vector2()

var previously_floored := false

var container_offset = Vector3(1.2, -1.1, -2.75)

var tween:Tween

var hud: HUD;

signal health_updated

@onready var head : Node3D = $Head
@onready var camera : Camera3D = $Head/Camera
@onready var raycast : RayCast3D = $Head/Camera/RayCast
@onready var muzzle : AnimatedSprite3D = $Head/Camera/SubViewportContainer/SubViewport/CameraItem/Muzzle
@onready var container : Node3D = $Head/Camera/SubViewportContainer/SubViewport/CameraItem/Container
@onready var sound_footsteps : AudioStreamPlayer = $SoundFootsteps
@onready var blaster_cooldown : Timer = $Cooldown
@onready var _inventory := Inventory.new(self)
@onready var _gun : Gun = $Gun

@export var crosshair:TextureRect


# Functions
func get_inventory() -> Inventory:
	return _inventory

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	_gun.init()
	hud = hud_scene.instantiate()
	hud.set_player(self)
	add_child(hud)

func _physics_process(delta):
	
	# Handle functions
	
	_handle_controls()
	_handle_gravity(delta)
	_handle_rotation(delta)
	
	_handle_movement(delta)
	
	#print("Velocity x %f, y %f, z %f" % [velocity.x, velocity.y, velocity.z])

	# Falling/respawning
	
	if position.y < -10:
		get_tree().reload_current_scene()

# Mouse movement

func _input(event):
	if event is InputEventMouseMotion and mouse_captured:
		_rotation_input -= event.relative / mouse_sensitivity

func _handle_controls():
	## Mouse capture
	if Input.is_action_just_pressed("mouse_capture"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		mouse_captured = true
	
	if Input.is_action_just_pressed("mouse_capture_exit"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		mouse_captured = false
	
	## Rotation
	_rotation_input += Input.get_vector("camera_right", "camera_left", "camera_down", "camera_up")

# Handle gravity

func _handle_gravity(delta: float):
	_upwards.y = clamp(_upwards.y + _gravity * delta, _gravity, -2 * _gravity)
	
	if !Input.is_action_just_pressed("jump"): return
	print("trying to jump")
	if !_ground.is_grounded: return
	print("actually jumping")
	
	Audio.play("sounds/jump_a.ogg, sounds/jump_b.ogg, sounds/jump_c.ogg")
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

	#if 
	#_ground_movement +=
	
	var travel := _ground_movement
	if !_ground.is_grounded || _upwards.y > 0.0:
		travel += _upwards
	
	travel *= delta
	#if was_on_ground:
		#var y_offset := 0.9 * absf(travel.y)
		#move_and_collide(Vector3.UP * y_offset)
		#if travel.y > 0.0:
			#travel.y -= y_offset
	
	for i in 5:
		var collision := move_and_collide(travel)
		if !is_instance_valid(collision):
			break
		
		var reflect_factor := 1.0
		if _ground.is_valid_ground(collision):
			_ground.reset(basis, collision)
			if !was_on_ground && _upwards.y < _bounce_threshold:
				reflect_factor += _ground.bounciness
		else:
			# do step raycast
			# null upwards movement
			_upwards.y = 0.0
		
		var normal := collision.get_normal()
		travel -= collision.get_travel()
		
		travel += normal * normal.dot(-travel) * reflect_factor
		_ground_movement += normal * normal.dot(-_ground_movement) * reflect_factor
		_upwards.y += normal.dot(-_upwards) * reflect_factor
	
	if _upwards.y > 0.05:
		_ground.reset(basis)

func _calc_ground_movement(delta: float):
	if !_ground.is_grounded:
		return _upwards
	
	## apply braking
	var accel_input := _project_on_ground(-_ground_movement)
	
	## apply accelerating
	var input := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	if input.length_squared() > 1.0:
		input = input.normalized()
	accel_input.x += input.x * _movement_speed
	accel_input.z += input.y * _movement_speed
	
	accel_input *= pow(_ground.friction, 2) * _acceleration
	
	## apply gravity slide
	if _upwards.y < 0.0:
		var slide := _project_on_ground(_upwards) * pow((1.0 - _ground.friction), 2)
		accel_input += slide
	
	_ground_movement += transform.basis * accel_input * delta

func _project_on_ground(vector: Vector3) -> Vector3:
	return Vector3(_ground.basis.x.dot(vector), _ground.basis.y.dot(vector), _ground.basis.z.dot(vector))
