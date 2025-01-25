class_name AmmoCounter
extends Control

@export var icon: TextureRect
@export var counter: Label
@export var selection: Panel

func init(ammo: AmmoInstance):
	ammo.ammo_count_changed.connect(_on_ammo_count_changed)
	icon.texture = ammo.get_type().get_icon()
	_on_ammo_count_changed(ammo.get_amount())
	
func set_selected(is_selected: bool):
	selection.visible = is_selected

func _on_ammo_count_changed(amount: int):
	counter.text = str(amount)
