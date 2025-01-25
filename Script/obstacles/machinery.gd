class_name Machinery
extends StaticBody3D

func gum_up(duration: float):
	process_mode = ProcessMode.PROCESS_MODE_DISABLED
	await get_tree().create_timer(duration).timeout
	process_mode = ProcessMode.PROCESS_MODE_INHERIT
