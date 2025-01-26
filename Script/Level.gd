extends Node3D


var timer : Timer;
var second: int = 1;
@export var seconds: int = 90;

var player: Gunner;

func _ready(): 
	
	timer = Timer.new()
	timer.connect("timeout",_on_timer_timeout)
	add_child(timer) 
	timer.start(seconds) 
	
func _process(delta: float) -> void:
	if player.get_menu().is_open() != timer.paused:
		timer.paused = player.get_menu().is_open()
		
	player.hud.timer.text = str(int(timer.get_time_left()))
	
func set_player(node: Gunner):
	player = node;
	
func _on_timer_timeout():
	player._end_menu._set_visible(true);
	timer.stop()
