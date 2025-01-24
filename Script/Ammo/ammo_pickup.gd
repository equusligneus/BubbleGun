class_name AmmoPickup
extends Node

@export var _type : AmmoType
@export var _count := 5 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node3D) -> void:
	# check is player
	# add ammo to inventory
	
	pass # Replace with function body.
