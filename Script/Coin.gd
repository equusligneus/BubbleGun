extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func blep(body: Node3D) -> void:
	if body is Gunner:
		(body as Gunner).hud._on_score_increased(1);
		print("Mr Blaze")
		queue_free()
		


func _on_body_entered(body: Node3D) -> void:
	if body is Gunner:
		(body as Gunner).hud._on_score_increased(1);
		print("Mr Blaze")
		queue_free()
