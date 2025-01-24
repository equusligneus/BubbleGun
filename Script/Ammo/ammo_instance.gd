class_name AmmoInstance
extends RefCounted

var _amount : int
var _ammo: AmmoType

func _init(type : AmmoType, count: int):
	_ammo = type
	_amount = count

func get_type() -> AmmoType:
	return _ammo

func add(amount: int):
	_amount += amount

func get_amount() -> int:
	return _amount

func shoot(position, direction):
	_amount -= 1
	pass
