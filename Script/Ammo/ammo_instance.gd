class_name AmmoInstance
extends RefCounted

signal ammo_count_changed(amount: int)

var _amount : int
var _ammo: AmmoType

func _init(type : AmmoType, count: int):
	_ammo = type
	_amount = count

func get_type() -> AmmoType:
	return _ammo

func add(amount: int):
	_amount += amount
	ammo_count_changed.emit(_amount)

func get_amount() -> int:
	return _amount
	
func is_empty():
	return _amount == 0

func spawn_bullet() -> Bullet:
	if is_empty(): return null
	_amount -= 1
	ammo_count_changed.emit(_amount)
	return _ammo.get_bullet()
