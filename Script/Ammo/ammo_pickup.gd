class_name AmmoPickup
extends Node

@export var _type : AmmoType
@export var _count := 5 

@onready var _sprite : Sprite3D = $CollisionShape3D/Sprite3D

func _ready():
	_sprite.texture = _type.get_icon()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_sprite.rotate(Vector3.UP, 15.0 * delta)

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		(body as Player).get_inventory().add_ammo(_type, _count)
