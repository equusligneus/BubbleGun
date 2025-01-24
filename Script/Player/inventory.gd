extends Node

signal ammo_type_added(instance: AmmoInstance)

var _ammunition : Array[AmmoInstance]
var _ammo_index : int = -1

func get_current() -> AmmoInstance:
	return _ammunition[_ammo_index] if _ammo_index > -1 else null

func select_prev():
	if _ammunition.is_empty():
		return
	_select(-1)

func select_next():
	if _ammunition.is_empty():
		return
	_select(1)

func add_ammo(type: AmmoType, amount: int):
	for ammo in _ammunition:
		if ammo.get_type() == type:
			ammo.add_count(amount)
			return
	
	var instance := AmmoInstance.new(type, amount)
	_ammunition.push_back(instance)
	ammo_type_added.emit(instance)

func _select(direction: int):
	var start_index = _ammo_index
	_ammo_index = wrapi(_ammo_index + direction, 0, _ammunition.size())
	
	while _ammunition[_ammo_index].get_amount() == 0 && _ammo_index != start_index:
		_ammo_index = wrapi(_ammo_index + direction, 0, _ammunition.size())
	
