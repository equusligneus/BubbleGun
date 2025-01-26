extends Node3D


var timer;
var second_timer;
var second: int = 1;
@export var seconds: int = 90;

var player: Gunner;

func _ready(): 
	
	timer = Timer.new()
	second_timer = Timer.new()
	timer.connect("timeout",_on_timer_timeout) 
	second_timer.connect("timeout", _update_hud)
	add_child(timer) 
	add_child(second_timer)
	timer.start(seconds) 
	second_timer.start(second);
	
func set_player(node: Gunner):
	player = node;

func _update_hud():
	second_timer = Timer.new()
	second_timer.connect("timeout", _update_hud)
	second_timer.start(second);
	var text = int(timer.get_time_left())
	player.hud.timer.text = str(text);

	
func _on_timer_timeout():
	get_tree().reload_current_scene()
