class_name AmmoPickup
extends Node

@export var _type : AmmoType
@export var _count := 5 

@onready var _outline : Node3D = $Outline
@onready var _sprite : Sprite3D = $Outline/Sprite
@export var _turn_speed := 5.0

@export var _timer: Timer

func _ready():
	_sprite.texture = _type.get_icon()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_sprite.rotate(Vector3.UP, _turn_speed * delta)

func _on_body_entered(body: Node3D) -> void:
	if !_timer.is_stopped(): return
	
	if body is Gunner:
		(body as Gunner).get_inventory().add_ammo(_type, _count)
		hibernate()
		
func hibernate():
	_outline.visible = false
	_timer.start()
	await _timer.timeout
	_outline.visible = true
	pass
