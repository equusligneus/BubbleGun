extends Node3D

@export var _sfx_path : String

func _on_body_entered(body: Node3D) -> void:
	if body is Gunner:
		(body as Gunner).hud._on_score_increased(1);
		Audio.play(_sfx_path)
		queue_free()
