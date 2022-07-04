extends Spatial


func _ready():
	pass # Replace with function body.



func _process(delta):
	if Input.is_key_pressed(KEY_F):
		var fps = 1.0 / delta
		print("fps " % fps)
