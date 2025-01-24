class_name AmmoType
extends Resource

@export var _bullet : PackedScene
@export var _icon: Texture2D

func get_bullet() -> Bullet:
	return _bullet.instantiate() as Bullet

func get_icon() -> Texture2D:
	return _icon
