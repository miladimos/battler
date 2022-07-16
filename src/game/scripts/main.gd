extends Spatial


func _ready():
	pass # Replace with function body.



func _process(delta):
	if Input.is_key_pressed(KEY_F):
		var fps = 1.0 / delta
		print("fps " % fps)
	
	#$fps_label.text = str(Engine.get_frames_per_second())
	
	# fullscreen 
	#OS.window_fullscreen = !OS.window_fullscreen

	# pause game
	#get_tree().paused = !get_tree().paused

