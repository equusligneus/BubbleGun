class_name HUD
extends Control

@export var ammo_counter_scene : PackedScene

@export var ammo_container : HBoxContainer

func set_player(player: Gunner):
	player.get_inventory().ammo_type_added.connect(_on_ammo_type_added)

func _on_ammo_type_added(ammo: AmmoInstance):
	var counter : AmmoCounter = ammo_counter_scene.instantiate()
	counter.init(ammo)
	ammo_container.add_child(counter)
