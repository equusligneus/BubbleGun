class_name HUD
extends Control

@export var ammo_counter_scene : PackedScene

@export var ammo_container : HBoxContainer

@export var score_container: HBoxContainer
@export var score: int;
@onready var score_hud: Label = $"Top Bar/ScoreContainer/Label2"
@onready var timer: Label = $"Top Bar/Time_left/time"


func set_player(player: Gunner):
	var inventory := player.get_inventory()
	inventory.ammo_type_added.connect(_on_ammo_type_added)
	inventory.ammo_selection_changed.connect(_on_ammo_type_selected)
	player.add_child(self)

func _on_ammo_type_added(ammo: AmmoInstance):
	var counter : AmmoCounter = ammo_counter_scene.instantiate()
	counter.init(ammo)
	ammo_container.add_child(counter)

func _on_ammo_type_selected(index: int):
	for item in ammo_container.get_child_count():
		var counter : AmmoCounter = ammo_container.get_child(item)
		counter.set_selected(index == item)

func _on_score_increased(add: int):
	score += add;
	score_hud.text = str(score);
	get_parent()._end_menu.score.text = str(score);
